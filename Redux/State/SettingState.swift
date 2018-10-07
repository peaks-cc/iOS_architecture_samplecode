import Foundation
import ReSwift
import RxSwift
import API
import GitHubAPI

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
//////////////////////////////////////////////////////////////////////////////////////////
public struct SettingState: ReSwift.StateType {
    public typealias ThisState = SettingState
    public typealias Response = API.Response<User>
    private var requestState: RequestState<Response> = .init()
    private var isAuthenticated = false
    private var connectionTypeForShouldRequest: ConnectionType {
        return requestState.hasResponse ? .implicitlyReload : .initialRequest
    }
    private var apiDomainError: APIDomainError? {
        return requestState.error
    }

    // Normal
    public private(set) var shouldRequestTrigger: ShouldRequestTrigger?
    public var shouldShowLoading: Bool {
        return requestState.initialRequesting
    }
    public var shouldShowUser: Bool {
        return requestState.hasResponse
    }
    public var shouldShowAuthenticated: Bool {
        return isAuthenticated
    }
    public var userName: String? {
        return requestState.response?.content.name
    }
    public var avatarURL: URL? {
        guard let url = requestState.response?.content.avatarUrl else { return nil }
        return URL(string: url)
    }

    // Error
    public var shouldShowNetworkError: Bool {
        return apiDomainError?.isNetworkError ?? false
    }
    public var shouldShowServerError: Bool {
        return apiDomainError?.isInternalServerError ?? false
    }
    public var shouldShowUnknownError: Bool {
        return apiDomainError != nil &&
            apiDomainError?.isNetworkError != true &&
            apiDomainError?.isInternalServerError != true
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension SettingState {
    public enum Action: ReSwift.Action {
        case requestStart(connectionType: ConnectionType)
        case requestSuccess(response: Response)
        case requestError(error: APIDomainError)

        public static func requestAsyncCreator(
                connectionType: ConnectionType,
                disposeBag: RxSwift.DisposeBag
        ) -> RequestAuthenticatedActionCreator {

            return { (_: AppState, store: DispatchingStoreType, accessToken: AccessToken) in
                store.dispatch(Action.requestStart(connectionType: connectionType))
                return ThunkAction(
                    GitHubAPI.DefaultAPI.userGetSingle(accessToken: accessToken)
                        .map { Action.requestSuccess(response: $0) }
                        .mapError { Action.requestError(error: $0) },
                    disposeBag: disposeBag)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension SettingState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        var state = state
        switch action {
        case let action as GlobalState.Action:
            guard state.isAuthenticated else { return state }
            switch action {
            case .changeAppTab(let appTab):
                if case .setting = appTab, state.requestState.connecting == false {
                    state.shouldRequestTrigger = ShouldRequestTrigger(state.connectionTypeForShouldRequest)
                }
            case .changeApplicationState(let appState):
                if case .didBecomeActive = appState, state.requestState.connecting == false {
                    state.shouldRequestTrigger = ShouldRequestTrigger(state.connectionTypeForShouldRequest)
                }
            }
        case let action as AuthenticationState.Action:
            switch action {
            case .changeAuthenticated(let isAuthenticated):
                if state.isAuthenticated != isAuthenticated && isAuthenticated {
                    state.shouldRequestTrigger = ShouldRequestTrigger(state.connectionTypeForShouldRequest)
                }
                state.isAuthenticated = isAuthenticated
            case .logout:
                break
            }
        case let action as ThisState.Action:
            switch action {
            case .requestStart(let connectionType):
                state.requestState = RequestState(requestState: state.requestState, connectionType: connectionType)
            case .requestSuccess(let response):
                state.requestState = RequestState(requestState: state.requestState, response: response)
            case .requestError(let error):
                state.requestState = RequestState(requestState: state.requestState, error: error)
            }
        default:
            break // Do not handle other action
        }
        return state
    }
}
