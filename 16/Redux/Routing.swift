import UIKit
import ReSwift

public protocol Transitionable {
    func transition(
        _ reduxStore: RxReduxStore,
        transitionStyle: Routing.TransitionStyle,
        from: UIViewController?,
        to routingPage: Routing.Page
    ) -> UIViewController?
}

public protocol Routerable: Transitionable {
    var rootViewController: UIViewController { get }
    func reset()
}

public struct Routing {
    public enum TransitionStyle {
        case push
        case present
        case presentWithDismissAll
        case pushWithoutAnimation
        case presentWithoutAnimation
        case presentWithDismissAllWithoutAnimation
    }

    public enum Page: Equatable {
        public static func == (lhs: Routing.Page, rhs: Routing.Page) -> Bool {
            switch (lhs, rhs) {
            case (.main, .main):
                return true
            case (.userRepositories, .userRepositories):
                return true
            case (.publicRepositories, .publicRepositories):
                return true
            case (let .repository(input1), let .repository(input2)):
                return input1 == input2
            case (.favorites, .favorites):
                return true
            case (.serviceUnavailable, .serviceUnavailable):
                return true
            case (.setting, .setting):
                return true
            case (.login, .login):
                return true
            case (let .webView(url1), let .webView(url2)):
                return url1.absoluteString == url2.absoluteString
            default:
                return false
            }
        }

        case main
        case userRepositories
        case publicRepositories
        case repository(RepositoryState.Input)
        case favorites
        case serviceUnavailable
        case setting
        case login
        case webView(url: URL)
    }
}
