import Foundation
import ReSwift
import RxSwift
import API

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - AppState
//////////////////////////////////////////////////////////////////////////////////////////
public struct AppState: StateType {
    public let disposeBag: RxSwift.DisposeBag = .init()

    // Unoptional State
    public var globalState: GlobalState = .init()
    public var routingState: RoutingState = .init()
    public var authenticationState: AuthenticationState = .init()
    public var favoritesState: FavoritesState = .init()
    public var settingState: SettingState = .init()

    // Optional State
    public var userRepositoriesState: UserRepositoriesState?
    public var publicRepositoriesState: PublicRepositoriesState?

    // Map State
    public var repositoryStateMap: [StateIdentifier: RepositoryState] = [:]
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
public func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    // InitializeAction
    if let action = action as? InitializeAction {
        return initializeReducer(action: action, state: state)
    }

    // DisposeAction
    if let action = action as? DisposeAction {
        return disposeReducer(action: action, state: state)
    }

    // StateIdentifierAction
    if let action = action as? StateMapAction {
        return stateMapReducer(action: action, state: state)
    }

    // Optional State
    if let thisState = state.userRepositoriesState {
        state.userRepositoriesState = UserRepositoriesState.reducer(action: action, state: thisState)
    }
    if let thisState = state.publicRepositoriesState {
        state.publicRepositoriesState = PublicRepositoriesState.reducer(action: action, state: thisState)
    }
    state.repositoryStateMap.forEach {
        state.repositoryStateMap[$0.0] = RepositoryState.reducer(action: action, state: $0.1)
    }

    // Unoptional State
    state.globalState = GlobalState.reducer(action: action, state: state.globalState)
    state.routingState = RoutingState.reducer(action: action, state: state.routingState)
    state.authenticationState = AuthenticationState.reducer(action: action, state: state.authenticationState)
    state.favoritesState = FavoritesState.reducer(action: action, state: state.favoritesState)
    state.settingState = SettingState.reducer(action: action, state: state.settingState)
    return state
}

public final class PublicRepositoriesInitializeAction: InitializeAction { }
public final class UserRepositoriesInitializeAction: InitializeAction { }
public final class RepositoryInitializeAction: InitializeAction {
    let input: RepositoryState.Input

    public init(_ input: RepositoryState.Input) {
        self.input = input
    }
}

func initializeReducer(action: InitializeAction, state: AppState) -> AppState {
    var state = state
    switch action {
    case is UserRepositoriesInitializeAction:
        state.userRepositoriesState = .init()
    case is PublicRepositoriesInitializeAction:
        state.publicRepositoriesState = .init()
    default:
        assertionFailureUnreachable()
    }
    return state
}

func disposeReducer(action: DisposeAction, state: AppState) -> AppState {
    var state = state
    if state.userRepositoriesState?.disposeBag === action.disposeBag {
        state.userRepositoriesState = nil
    }
    if state.publicRepositoriesState?.disposeBag === action.disposeBag {
        state.publicRepositoriesState = nil
    }
    return state
}

func stateMapReducer(action: StateMapAction, state: AppState) -> AppState {
    var state = state
    if action.isStateType(RepositoryState.self) {
        switch action.originalAction {
        case let a as RepositoryInitializeAction:
            state.repositoryStateMap[action.stateIdentifier] = RepositoryState.init(a.input)
        case is DisposeAction:
            state.repositoryStateMap[action.stateIdentifier] = nil
        default:
            state = appReducer(action: action.originalAction, state: state)
            guard let thisState = state.repositoryStateMap[action.stateIdentifier] else { return state }
            state.repositoryStateMap[action.stateIdentifier] =
                RepositoryState.reducer(action: action.originalAction, state: thisState)
        }
    }
    return state
}
