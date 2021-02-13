import UIKit
import RxSwift
import RxCocoa
import Redux
import ReSwift

final class Router: Routerable, Transitionable {
    let rootViewController: UIViewController // For Routerable
    private let disposeBag: RxSwift.DisposeBag = .init()

    init(rootViewController: UIViewController = RootViewController()) {
        self.rootViewController = rootViewController
    }

    // For Routerable
    func reset() {
        rootViewController.dismiss(animated: false, completion: nil)
        rootViewController.children.forEach { // Remove old vcs
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }

    // For Transitionable
    @discardableResult
    func transition(
        _ reduxStore: RxReduxStore,
        transitionStyle: Routing.TransitionStyle,
        from: UIViewController?,
        to routingPage: Routing.Page
    ) -> UIViewController? {
        guard let from = from else { return nil }
        switch transitionStyle {
        case .push:
            return push(reduxStore, from: from, to: routingPage, animated: true)
        case .present:
            return present(reduxStore, from: from, to: routingPage, animated: true)
        case .presentWithDismissAll:
            return presentWithDismissAll(reduxStore, to: routingPage, animated: true)
        case .pushWithoutAnimation:
            return push(reduxStore, from: from, to: routingPage, animated: false)
        case .presentWithoutAnimation:
            return present(reduxStore, from: from, to: routingPage, animated: false)
        case .presentWithDismissAllWithoutAnimation:
            return presentWithDismissAll(reduxStore, to: routingPage, animated: false)
        }
    }

    @discardableResult
    func push(
        _ reduxStore: RxReduxStore,
        from: UIViewController,
        to routingPage: Routing.Page,
        animated: Bool
    ) -> UIViewController? {
        let vc = Router.controller(reduxStore, routingPage: routingPage)
        guard let navigationController = from.navigationController else {
            assertionFailureUnreachable()
            return nil
        }
        navigationController.pushViewController(vc, animated: animated)
        return vc
    }

    @discardableResult
    func present(
        _ reduxStore: RxReduxStore,
        from: UIViewController,
        to routingPage: Routing.Page,
        enalbeCloseButton: Bool = true,
        animated: Bool = true
    ) -> UIViewController? {
        let (navi, vc) = preparePresnt(reduxStore,
                                       to: routingPage,
                                       enalbeCloseButton: enalbeCloseButton,
                                       animated: animated
        )
        from.present(navi, animated: animated, completion: nil)
        return vc
    }

    private func preparePresnt(
        _ reduxStore: RxReduxStore,
        to routingPage: Routing.Page,
        enalbeCloseButton: Bool = true,
        animated: Bool = true
    ) -> (UINavigationController, UIViewController) {
        let vc = Router.controller(reduxStore, routingPage: routingPage)
        let navi = UINavigationController(rootViewController: vc)
        if enalbeCloseButton {
            let item = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
            item.rx.tap
                .bind(to: Binder(vc) { vc, _ in vc.dismiss(animated: true, completion: nil) })
                .disposed(by: disposeBag)
            vc.navigationItem.leftBarButtonItem = item
        }
        return (navi, vc)
    }

    @discardableResult
    func presentWithDismissAll(
        _ reduxStore: RxReduxStore,
        to routingPage: Routing.Page,
        enalbeCloseButton: Bool = true,
        animated: Bool = true
    ) -> UIViewController? {
        let (navi, vc) = preparePresnt(reduxStore,
                                       to: routingPage,
                                       enalbeCloseButton: enalbeCloseButton,
                                       animated: animated
        )
        rootViewController.dismiss(animated: true, completion: { [weak self] in
            self?.rootViewController.present(navi, animated: animated, completion: nil)
        })
        return vc
    }

    static func mapToState<State: ReSwift.StateType>(_ reduxStore: RxReduxStore, transform: @escaping (AppState) throws -> State?) -> Observable<State> {
        return reduxStore.stateObservable
            .compactMap(transform)
            .share(replay: 1)
    }

    // swiftlint:disable function_body_length
    static func controller(_ reduxStore: RxReduxStore, routingPage: Routing.Page) -> UIViewController {
        switch routingPage {
        case .main:
            let state = mapToState(reduxStore, transform: { $0.authenticationState })
            let disposeBag = reduxStore.state.disposeBag
            let vc = MainViewController(
                reduxStore: reduxStore,
                state: state,
                disposeBag: disposeBag
            )
            return vc
        case .userRepositories: // Optional State
            reduxStore.dispatch(UserRepositoriesInitializeAction())
            let state = mapToState(reduxStore, transform: { $0.userRepositoriesState })
            let disposeBag = reduxStore.state.userRepositoriesState?.disposeBag
                            ?? { assertionFailureUnreachable(); return .init() }()
            let vc = UserRepositoriesViewController(
                reduxStore: reduxStore,
                state: state,
                disposeBag: disposeBag
            )
            return vc
        case .publicRepositories: // Optional State
            reduxStore.dispatch(PublicRepositoriesInitializeAction())
            let state = mapToState(reduxStore, transform: { $0.publicRepositoriesState })
            let disposeBag = reduxStore.state.publicRepositoriesState?.disposeBag
                            ?? { assertionFailureUnreachable(); return .init() }()
            let vc = PublicRepositoriesViewController(
                reduxStore: reduxStore,
                state: state,
                disposeBag: disposeBag
            )
            return vc
        case .repository(let input): // Map State
            let stateIdentifier: StateIdentifier = .init(RepositoryState.self)
            let stateMapReduxStore = RxStateMapReduxStore(reduxStore, stateIdentifier: stateIdentifier)
            stateMapReduxStore.dispatch(RepositoryInitializeAction(input))
            let state = mapToState(reduxStore, transform: { $0.repositoryStateMap[stateIdentifier] })
            let disposeBag = reduxStore.state.repositoryStateMap[stateIdentifier]?.disposeBag
                                    ?? { assertionFailureUnreachable(); return .init() }()
            let vc = RepositoryViewController(
                reduxStore: stateMapReduxStore,
                state: state,
                stateIdentifier: stateIdentifier,
                input: input,
                disposeBag: disposeBag
            )
            return vc
        case .favorites:
            let disposeBag: RxSwift.DisposeBag = reduxStore.state.disposeBag
            let state = mapToState(reduxStore, transform: { $0.favoritesState })
            let vc = FavoritesViewController(reduxStore: reduxStore, state: state, disposeBag: disposeBag)
            return vc
        case .serviceUnavailable:
            let vc = ServiceUnavailableViewController(reduxStore: reduxStore)
            return vc
        case .setting:
            let disposeBag: RxSwift.DisposeBag = reduxStore.state.disposeBag
            let state = mapToState(reduxStore, transform: { $0.settingState })
            let vc = SettingViewController(reduxStore: reduxStore, state: state, disposeBag: disposeBag)
            return vc
        case .login:
            assert(GitHubClientID.count > 0)
            assert(GitHubClientSecret.count > 0)
            let vc = LoginWebViewController(reduxStore: reduxStore,
                                            clientID: GitHubClientID,
                                            clientSecret: GitHubClientSecret,
                                            redirectURL: GitHubRedirectURL)
            return vc
        case .webView(let url):
            let vc = WebViewController(reduxStore: reduxStore, url: url)
            return vc
        }
    }
    // swiftlint:enable function_body_length
}
