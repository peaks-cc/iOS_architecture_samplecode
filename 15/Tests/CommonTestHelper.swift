import UIKit
import XCTest
import ReSwift
import RxSwift
import RxBlocking
import Mockingjay
import SwiftyBeaver
@testable import ReduxExample
@testable import Redux
@testable import API

// swiftlint:disable identifier_name
let TestKeychainServiceeName = "TestKeychainServicee"
let TestUserDefaultsName = "TestUserDefaultsName"
// swiftlint:enable identifier_name

let logger = SwiftyBeaver.self

func createTestMiddleware(append: [Redux.MiddlewareFunction] = [], enableThunkBlocking: Bool = true) -> [Redux.MiddlewareFunction] {
    var middleware = [Redux.MiddlewareFunction]()
    middleware.append(Redux.debugLoggingMiddleware)
    middleware.append(thunkBlockingMiddleware) // Append thunkBlockingMiddlewar
    if enableThunkBlocking { middleware.append(Redux.thunkMiddleware) }
    middleware.append(Redux.thunkStateMapMiddleware)
    middleware.append(Redux.responseErrorConcernMiddleware)
    middleware.append(contentsOf: append)
    return middleware
}

func createTestReSwiftSrore(_ middleware: [Redux.MiddlewareFunction] = createTestMiddleware()) -> ReSwift.Store<AppState> {
    return ReSwift.Store<AppState>(reducer: appReducer, state: nil, middleware: middleware)
}

func createTestUserDefaults() -> UserDefaults {
    return UserDefaults(suiteName: TestUserDefaultsName)!
}

func createTestRxReduxStore(
        store: ReSwift.Store<AppState> = createTestReSwiftSrore(),
        router: Routerable = TestRouter(),
        keychainStore: KeychainStorable = KeychainStore(TestKeychainServiceeName),
        userDefaults: UserDefaults = createTestUserDefaults(),
        accessToken: API.AccessToken? = nil
    ) -> RxReduxStore {

    let reduxStore = RxReduxStore(
        store: store,
        router: router,
        keychainStore: keychainStore,
        userDefaults: userDefaults,
        accessToken: accessToken
    )
    return reduxStore
}

struct TestRouter: Routerable {
    typealias MockRouterFunction = (
        _ reduxStore: RxReduxStore,
        _ transitionStyle: Routing.TransitionStyle,
        _ from: UIViewController?,
        _ routingPage: Routing.Page
        ) -> ()
    var rootViewController: UIViewController
    var mockRouter: MockRouterFunction?

    init(
        rootViewController: UIViewController = UIViewController(),
        mockRouter: MockRouterFunction? = nil
    ) {
        self.rootViewController = rootViewController
        self.mockRouter = mockRouter
    }

    func reset() {
        // Do Nothing
    }

    func transition(
        _ reduxStore: RxReduxStore,
        transitionStyle: Routing.TransitionStyle,
        from: UIViewController?,
        to routingPage: Routing.Page
    ) -> UIViewController? {
        mockRouter?(
            reduxStore,
            transitionStyle,
            from,
            routingPage
        )
        return nil
    }
}

// swiftlint:disable force_try
let thunkBlockingMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            if let action = action as? ThunkAction {
                let blocking = try! action.single.toBlocking().single()
                let single = RxSwift.Single<ReSwift.Action>.create { observer -> Disposable in
                    observer(.success(blocking))
                    return Disposables.create()
                }
                next(ThunkAction(single, disposeBag: action.disposeBag))
            } else {
                return next(action)
            }
        }
    }
}
// swiftlint:enable force_try

let failureTimedOut = failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut))

// swiftlint:disable force_cast
extension DataSourceElements {
    func element<T: Diffable>(indexAt: Int) -> T {
        return (elements[indexAt] as! DiffableWrap<T>).diffable
    }
}
// swiftlint:enable force_cast
