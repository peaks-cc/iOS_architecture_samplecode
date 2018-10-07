import Foundation
import ReSwift
import RxSwift
import API

public typealias ReduxStoreType = ReSwift.DispatchingStoreType &
                                    HasAppStateType &
                                    ActionCreatorables

public typealias ActionCreatorables = RequestActionCreatorable &
                                    RequestAuthenticatedActionCreatorable &
                                    KeychainForAccessTokenActionCreatorable &
                                    UserDefaultsActionCreatorable &
                                    TransitionActionCreatorable

public typealias AccessTokenReceiver = (_ accessToken: AccessToken?) -> ()
public typealias RequestActionCreator = (
    _ state: AppStateType,
    _ store: DispatchingStoreType
    ) -> ReSwift.Action?

public typealias RequestAuthenticatedActionCreator = (
    _ state: AppStateType,
    _ store: DispatchingStoreType,
    _ accessToken: AccessToken
    ) -> ReSwift.Action?

public typealias KeychainForAccessTokenActionCreator = (
    _ state: AppStateType,
    _ keychain: KeychainStorable,
    _ accessTokenReceiver: AccessTokenReceiver
    ) -> ReSwift.Action?

public typealias UserDefaultsActionCreator = (
    _ state: AppStateType,
    _ userDefaults: UserDefaults
    ) -> ReSwift.Action?

public typealias TransitionActionCreator = (
    _ reduxStore: RxReduxStore,
    _ transitioner: Transitionable
    ) -> ReSwift.Action?

public protocol RequestActionCreatorable {
    func dispatch(
        _ actionCreatorProvider: @escaping RequestActionCreator
    )
}
public protocol RequestAuthenticatedActionCreatorable {
    func dispatch(
        _ actionCreatorProvider: @escaping RequestAuthenticatedActionCreator
    )
}
public protocol KeychainForAccessTokenActionCreatorable {
    func dispatch(
        _ actionCreatorProvider: @escaping KeychainForAccessTokenActionCreator
    )
}
public protocol UserDefaultsActionCreatorable {
    func dispatch(
        _ actionCreatorProvider: @escaping UserDefaultsActionCreator
    )
}
public protocol TransitionActionCreatorable {
    func dispatch(
        _ actionCreatorProvider: @escaping TransitionActionCreator
    )
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - RxReduxStore
//////////////////////////////////////////////////////////////////////////////////////////
public class RxReduxStore: RxWrappedStore, ActionCreatorables {
    private let router: Routerable
    private let keychainStore: KeychainStorable
    private let userDefaults: UserDefaults
    private var accessToken: AccessToken?

    public init(
        store: ReSwift.Store<AppStateType>, // to wrap store
        router: Routerable, // DI
        keychainStore: KeychainStorable, // DI
        userDefaults: UserDefaults, // DI
        accessToken: AccessToken? // DI
        ) {
        self.router = router
        self.keychainStore = keychainStore
        self.userDefaults = userDefaults
        self.accessToken = accessToken
        super.init(store: store)
    }

    deinit {
        logger.info("🎃🎃🎃 DEINIT ReduxStore 🎃🎃🎃")
    }

    // RequestActionCreatorable
    func create( _ actionCreatorProvider: @escaping RequestActionCreator) -> ReSwift.Action? {
        return actionCreatorProvider(state, self)
    }

    public func dispatch(_ actionCreatorProvider: @escaping RequestActionCreator) {
        guard let action = create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    // RequestAuthenticatedActionCreatorable
    func create( _ actionCreatorProvider: @escaping RequestAuthenticatedActionCreator) -> ReSwift.Action? {
        guard let accessToken = accessToken else { assertionFailureUnreachable(); return nil }
        return actionCreatorProvider(state, self, accessToken)
    }

    public func dispatch( _ actionCreatorProvider: @escaping RequestAuthenticatedActionCreator) {
        guard let action = create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    // KeychainForAccessTokenActionCreatorable
    func create( _ actionCreatorProvider: @escaping KeychainForAccessTokenActionCreator) -> ReSwift.Action? {
        let accessTokenReceiver: AccessTokenReceiver = { [weak self] (accessToken: AccessToken?) in
            self?.accessToken = accessToken
        }
        return actionCreatorProvider(state, keychainStore, accessTokenReceiver)
    }

    public func dispatch(_ actionCreatorProvider: @escaping KeychainForAccessTokenActionCreator) {
        guard let action = create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    // UserDefaultsActionCreatorable
    func create( _ actionCreatorProvider: @escaping TransitionActionCreator) -> ReSwift.Action? {
        return actionCreatorProvider(self, router)
    }

    public func dispatch(_ actionCreatorProvider: @escaping TransitionActionCreator) {
        guard let action = create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    // TransitionActionCreatorable
    func create( _ actionCreatorProvider: @escaping UserDefaultsActionCreator) -> ReSwift.Action? {
        return actionCreatorProvider(state, userDefaults)
    }

    public func dispatch(_ actionCreatorProvider: @escaping UserDefaultsActionCreator) {
        guard let action = create(actionCreatorProvider) else { return }
        dispatch(action)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - RxStateMapReduxStore
//////////////////////////////////////////////////////////////////////////////////////////
public class RxStateMapReduxStore: ReduxStoreType {
    private let reduxStore: RxReduxStore
    private let stateIdentifier: StateIdentifier
    public var state: AppStateType { return self.reduxStore.state }

    public init(_ reduxStore: RxReduxStore, stateIdentifier: StateIdentifier) {
        self.reduxStore = reduxStore
        self.stateIdentifier = stateIdentifier
    }

    public func dispatch(_ action: ReSwift.Action) {
        reduxStore.dispatch(
            StateMapAction(stateIdentifier, action: action)
        )
    }

    public func dispatch(_ actionCreatorProvider: @escaping RequestActionCreator) {
        guard let action = reduxStore.create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    public func dispatch( _ actionCreatorProvider: @escaping RequestAuthenticatedActionCreator) {
        guard let action = reduxStore.create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    public func dispatch(_ actionCreatorProvider: @escaping KeychainForAccessTokenActionCreator) {
        guard let action = reduxStore.create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    public func dispatch(_ actionCreatorProvider: @escaping UserDefaultsActionCreator) {
        guard let action = reduxStore.create(actionCreatorProvider) else { return }
        dispatch(action)
    }

    public func dispatch(_ actionCreatorProvider: @escaping TransitionActionCreator) {
        guard let action = reduxStore.create(actionCreatorProvider) else { return }
        dispatch(action)
    }
}
