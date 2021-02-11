import Foundation
import ReSwift
import RxSwift
import RxCocoa
import API

public typealias AppStateType = AppState

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Middleware
//////////////////////////////////////////////////////////////////////////////////////////
public typealias DispatchFunctionClosure = (@escaping ReSwift.DispatchFunction) -> ReSwift.DispatchFunction
public typealias MiddlewareFunction = (@escaping ReSwift.DispatchFunction, @escaping () -> AppState?) -> DispatchFunctionClosure

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Store
//////////////////////////////////////////////////////////////////////////////////////////
public protocol HasAppStateType {
    var state: AppStateType { get }
}
public class RxWrappedStore: ReSwift.StoreSubscriber, ReSwift.DispatchingStoreType, HasAppStateType {
    public var state: AppStateType { return self.store.state }
    public lazy var stateObservable: RxSwift.Observable<AppStateType> = {
        return self.stateBehaviorRelay
            .observe(on: MainScheduler.instance)
            .share(replay: 1)
    }()
    private lazy var stateBehaviorRelay: RxCocoa.BehaviorRelay<AppStateType> = {
        return .init(value: self.state)
    }()
    private let store: ReSwift.Store<AppStateType>

    public init(store: ReSwift.Store<AppStateType>) {
        self.store = store
        self.store.subscribe(self)
    }

    deinit {
        store.unsubscribe(self)
    }

    public func newState(state: AppStateType) {
        logger.verbose("\n🎾" + dumpState(state))
        stateBehaviorRelay.accept(state)
    }

    public func dispatch(_ action: ReSwift.Action) {
        if Thread.isMainThread {
            store.dispatch(action)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.store.dispatch(action)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
public class InitializeAction: ReSwift.Action {
    public init() { }
}

public struct DisposeAction: ReSwift.Action {
    let disposeBag: RxSwift.DisposeBag

    public init(_ disposeBag: RxSwift.DisposeBag) {
        self.disposeBag = disposeBag
    }
}

public struct StateIdentifier: Identifierable, Hashable {
    public let identifier: Identifier = .init()
    public let stateType: ReSwift.StateType.Type

    public init(_ stateType: ReSwift.StateType.Type) {
        self.stateType = stateType
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public struct StateMapAction: ReSwift.Action {
    public let stateIdentifier: StateIdentifier
    public let originalAction: ReSwift.Action

    public init(_ stateIdentifier: StateIdentifier, action: ReSwift.Action) {
        self.stateIdentifier = stateIdentifier
        self.originalAction = action
    }

    func isStateType(_ stateType: ReSwift.StateType.Type) -> Bool {
        return stateIdentifier.stateType == stateType
    }
}

public struct ThunkAction: ReSwift.Action {
    public let single: RxSwift.Single<ReSwift.Action>
    public let disposeBag: RxSwift.DisposeBag
    public let file: String // For Debug
    public let function: String // For Debug

    public init(
        _ single: Single<ReSwift.Action>,
        disposeBag: RxSwift.DisposeBag,
        file: String = #file,
        function: String = #function
    ) {
        self.single = single
        self.disposeBag = disposeBag
        self.file = file
        self.function = function
    }
}

struct DoNothingAction: ReSwift.Action {
    public let logMessage: String

    init (
        _ logMessage: String = "",
        file: String = #file,
        function: String = #function
    ) {
        self.logMessage = logMessage
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - AppState Helper
//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - App State Protocol
public protocol HasDataSourceElements {
    var dataSourceElements: DataSourceElements { get }
}

public protocol HasDisposeBag {
    var disposeBag: RxSwift.DisposeBag { get }
}

// MARK: - App State Helper
public struct ShouldTrigger: Identifierable {
    public let identifier: Identifier = .init()
}

public struct ShouldRequestTrigger: Identifierable {
    public let identifier: Identifier = .init()
    public let connectionType: ConnectionType

    init(_ connectionType: ConnectionType) {
        self.connectionType = connectionType
    }
}

public struct ErrorNotificationTrigger: Identifierable {
    public let identifier: Identifier = .init()
    public let message: String
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action Helper
//////////////////////////////////////////////////////////////////////////////////////////
extension PrimitiveSequence where Trait == SingleTrait, Element == ReSwift.Action {
    public typealias Handler = (APIDomainError) -> Element
    public func mapError(_ handler: @escaping Handler) -> PrimitiveSequence<Trait, Element> {
        self.catch { (error: Error) -> PrimitiveSequence<Trait, Element> in
            let apiDomainError: APIDomainError
            if let error = error as? APIDomainError {
                apiDomainError = error
            } else {
                assertionFailureUnreachable()
                apiDomainError = APIDomainError.unreachable
            }
            let originalAction = handler(apiDomainError)
            let concernAction = ReponseErrorConcernAction(
                originalAction: originalAction,
                apiDomainError: apiDomainError
            )
            return PrimitiveSequence<Trait, Element>.just(concernAction)
        }
    }
}
