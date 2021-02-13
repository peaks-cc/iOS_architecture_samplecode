import Foundation
import ReSwift
import RxSwift
import KeychainAccess
import API

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Thunk
//////////////////////////////////////////////////////////////////////////////////////////
public let thunkMiddleware: ReSwift.Middleware<AppState> = { _, _ in
    return { next in
        return { action in
            if let action = action as? ThunkAction {
                action.single
                    .observe(on: MainScheduler.instance)
                    .subscribe(onSuccess: {
                        next($0)
                    })
                    .disposed(by: action.disposeBag)
            } else {
                return next(action)
            }
        }
    }
}

public let thunkStateMapMiddleware: ReSwift.Middleware<AppState> = { _, _ in
    return { next in
        return { action in
          if let s = action as? StateMapAction, let action = s.originalAction as? ThunkAction {
                action.single
                    .observe(on: MainScheduler.instance)
                    .subscribe(onSuccess: {
                        next(StateMapAction(s.stateIdentifier, action: $0))
                    })
                    .disposed(by: action.disposeBag)
            } else {
                return next(action)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - For Debug
//////////////////////////////////////////////////////////////////////////////////////////
#if DEBUG
public let debugLoggingMiddleware: ReSwift.Middleware<AppState> = { _, _ in
    return { next in
        return { action in
            if let action = action as? ThunkAction {
                // Do nothing
            } else {
                logger.info("\n🔥 [Action] \(String(describing: action))")
            }
            return next(action)
        }
    }
}

public let debugDelayRequestMiddleware: ReSwift.Middleware<AppState> = { _, _ in
    return { next in
        return { action in
            if let action = action as? ThunkAction {
                let single = action.single.delaySubscription(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                let singleAction = ThunkAction(
                                        single, disposeBag:
                                        action.disposeBag,
                                        file: action.file,
                                        function: action.function
                                    )
                return next(singleAction)
            } else {
                return next(action)
            }
        }
    }
}
#endif
