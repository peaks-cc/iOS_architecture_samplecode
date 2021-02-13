import Foundation
import ReSwift
import RxSwift
import API

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
public struct ReponseErrorConcernAction: ReSwift.Action {
    let originalAction: ReSwift.Action
    let apiDomainError: APIDomainError

    init(originalAction: ReSwift.Action, apiDomainError: APIDomainError) {
        self.originalAction = originalAction
        self.apiDomainError = apiDomainError
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Middleware
//////////////////////////////////////////////////////////////////////////////////////////
public let responseErrorConcernMiddleware: ReSwift.Middleware<AppState> = { dispatch, _ in
    return { next in
        return { action in
            if let action = action as? ReponseErrorConcernAction {
                if case .response(let error) = action.apiDomainError {
                    switch error.statusCode {
                    case serviceUnavailable:
                        // Workaround: want to use TransitionActionCreator.
                        // `Dispatch` is to receive only an `Action`.
                        dispatch(RoutingState.Action.shouldShowServiceUnavailable)
                    case unauthorized:
                        dispatch(AuthenticationState.Action.logout)
                    return // No more next, because the logout is to destroy the redux store.
                    default:
                        break
                    }
                }
                return next(action.originalAction)
            } else {
                return next(action)
            }
        }
    }
}
