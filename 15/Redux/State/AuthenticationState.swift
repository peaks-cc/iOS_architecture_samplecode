import Foundation
import ReSwift
import API

// swiftlint:disable identifier_name
private let AccessTokenKey = "AccessToken"
// swiftlint:enable identifier_name

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
//////////////////////////////////////////////////////////////////////////////////////////
public struct AuthenticationState: ReSwift.StateType {
    public typealias ThisState = AuthenticationState
    public var isAuthenticated = false
    public var shouldLogoutTriger: ShouldTrigger?
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension AuthenticationState {
    public enum Action: ReSwift.Action {
        case changeAuthenticated(isAuthenticated: Bool)
        case logout

        public static func keychainSaveAccessTokenCreator(accessToken: AccessToken) -> KeychainForAccessTokenActionCreator {
            return { (_: AppState, keychain: KeychainStorable, accessTokenReceiver: AccessTokenReceiver) in
                keychain.save(key: AccessTokenKey, value: accessToken)
                accessTokenReceiver(accessToken)
                return Action.changeAuthenticated(isAuthenticated: true)
            }
        }

        public static func keychainLoadAccessTokenCreator() -> KeychainForAccessTokenActionCreator {
            return { (_: AppState, keychain: KeychainStorable, accessTokenReceiver: AccessTokenReceiver) in
                guard let accessToken = keychain.load(key: AccessTokenKey) else {
                    accessTokenReceiver(nil)
                    return Action.changeAuthenticated(isAuthenticated: false)
                }
                accessTokenReceiver(accessToken)
                return Action.changeAuthenticated(isAuthenticated: true)
            }
        }

        public static func keychainDeleteAccessTokenCreator() -> KeychainForAccessTokenActionCreator {
            return { (_: AppState, keychain: KeychainStorable, accessTokenReceiver: AccessTokenReceiver) in
                keychain.delete(key: AccessTokenKey)
                accessTokenReceiver(nil)
                return Action.changeAuthenticated(isAuthenticated: false)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension AuthenticationState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        guard let action = action as? ThisState.Action else { return state }
        var state = state
        switch action {
        case .changeAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
        case .logout:
            state.shouldLogoutTriger = ShouldTrigger()
        }
        return state
    }
}
