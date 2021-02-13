import UIKit
import ReSwift
import RxSwift
import RxCocoa
import SwiftyBeaver
import Redux
import GitHubAPI

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - createReSwiftSrore
//////////////////////////////////////////////////////////////////////////////////////////
func createReSwiftSrore() -> ReSwift.Store<AppState> {
    var middleware = [Redux.MiddlewareFunction]()
    #if DEBUG
    middleware.append(debugLoggingMiddleware)
    middleware.append(debugDelayRequestMiddleware)
    #endif
    middleware.append(thunkMiddleware)
    middleware.append(thunkStateMapMiddleware)
    middleware.append(responseErrorConcernMiddleware)
    return ReSwift.Store<AppState>(reducer: appReducer, state: nil, middleware: middleware)
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - AppTab
//////////////////////////////////////////////////////////////////////////////////////////
final class AppTab {
    let tabbarViewController: UITabBarController

    init(tabbarViewController: UITabBarController = UITabBarController()) {
        self.tabbarViewController = tabbarViewController
    }

    func prepare(_ reduxStore: RxReduxStore, rootViewController: UIViewController) {
        let vcs: [UIViewController] = {
            // swiftlint:disable superfluous_disable_command
            var vcs: [UIViewController] = [
            {
                let vc = Router.controller(reduxStore, routingPage: .main)
                let i = UIImage(asset: Asset.repo)
                vc.tabBarItem = UITabBarItem(title: "Repo", image: i, selectedImage: nil)
                return vc
            }(),
            {
                let vc = Router.controller(reduxStore, routingPage: .favorites)
                let i = UIImage(asset: Asset.favorite)
                vc.tabBarItem = UITabBarItem(title: "Favorite", image: i, selectedImage: nil)
                return vc
            }(),
            {
                let vc = Router.controller(reduxStore, routingPage: .setting)
                let i = UIImage(asset: Asset.account)
                vc.tabBarItem = UITabBarItem(title: "Account", image: i, selectedImage: nil)
                return vc
            }()
            ]
            // swiftlint:enable opening_brace

            #if DEBUG
            vcs.append({
                let vc = DebugIGListKitCatalogViewController(reduxStore: reduxStore)
                let i = UIImage(asset: Asset.catalog)
                vc.tabBarItem = UITabBarItem(title: "UI Catalog", image: i, selectedImage: nil)
                return vc
                }())
            #endif
            return vcs
        }()

        let navs = vcs.map { UINavigationController(rootViewController: $0) }
        tabbarViewController.setViewControllers(navs, animated: false)

        tabbarViewController.view.frame = rootViewController.view.bounds
        rootViewController.addChild(tabbarViewController)
        rootViewController.view.addSubview(tabbarViewController.view)
        tabbarViewController.didMove(toParent: rootViewController)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - AppMain
//////////////////////////////////////////////////////////////////////////////////////////
final class AppMain {
    fileprivate var disposeBag: RxSwift.DisposeBag = .init() // will be remaked after logout
    fileprivate var reduxStore: RxReduxStore // will be remaked after logout
    fileprivate var appTab: AppTab // will be remaked after logout
    fileprivate let router: Routerable
    fileprivate let keychainStore: KeychainStorable
    fileprivate let userDefaults: UserDefaults

    init(
        store: ReSwift.Store<AppState> = createReSwiftSrore(),
        router: Routerable = Router(), // DI
        keychainStore: KeychainStorable = KeychainStore(KeychainServiceeName), // DI
        userDefaults: UserDefaults = UserDefaults.standard // DI
    ) {
        self.router = router
        self.keychainStore = keychainStore
        self.userDefaults = userDefaults
        self.reduxStore = RxReduxStore(
                                store: store,
                                router: router,
                                keychainStore: keychainStore,
                                userDefaults: userDefaults,
                                accessToken: nil)
        self.appTab = AppTab()
        prepare()
    }

    func prepare() {
        appTab.prepare(reduxStore, rootViewController: router.rootViewController)

        appTab.tabbarViewController.rx.didSelect
            .bind(to: Binder(self) { $0.didSelectTabBar($1) })
            .disposed(by: disposeBag)

        reduxStore.stateObservable
            .compactMap { $0.authenticationState.shouldLogoutTriger }
            .distinctUntilChanged()
            .bind(to: Binder(self) { me, _ in me.logout() })
            .disposed(by: disposeBag)

        reduxStore.stateObservable
            .compactMap { $0.routingState.shouldShowServiceUnavailableTriger }
            .distinctUntilChanged()
            .bind(to: Binder(self) { me, _ in me.presentServiceUnavailable() })
            .disposed(by: disposeBag)

        reduxStore.dispatch(AuthenticationState.Action.keychainLoadAccessTokenCreator())
    }

    func didSelectTabBar(_ viewController: UIViewController) {
        let vc = (viewController as? UINavigationController)?.viewControllers.first ?? viewController
        switch vc {
        case is MainViewController:
            self.reduxStore.dispatch(GlobalState.Action.changeAppTab(appTab: .main))
        case is FavoritesViewController:
            self.reduxStore.dispatch(GlobalState.Action.changeAppTab(appTab: .favorites))
        case is SettingViewController:
            self.reduxStore.dispatch(GlobalState.Action.changeAppTab(appTab: .setting))
        default:
            #if DEBUG
            if vc is DebugIGListKitCatalogViewController { return }
            #endif
            assertionFailureUnreachable()
        }
    }

    func presentServiceUnavailable() {
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .presentWithDismissAll,
                to: .serviceUnavailable
            )
        )
    }

    func logout() {
        assert(Thread.isMainThread)
        do { // Remake
            disposeBag = .init()
            reduxStore = RxReduxStore(
                store: createReSwiftSrore(),
                router: router,
                keychainStore: keychainStore,
                userDefaults: userDefaults,
                accessToken: nil
            )
            appTab = AppTab()
        }
        reduxStore.dispatch(AuthenticationState.Action.keychainDeleteAccessTokenCreator())
        router.reset()
        prepare()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - AppDelegate
//////////////////////////////////////////////////////////////////////////////////////////
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appMain = AppMain()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        do { // Logger settings
            #if DEBUG
            let console = ConsoleDestination()
            console.minLevel = .debug // just log .verbose .debug .info, .Warning & .error
            console.useNSLog = false
            logger.addDestination(console)
            #endif
        }

        do { // Request headers settings
            var customHeaders: [String: String] = [
                "Cache-Control": "no-cache"
            ]
            #if !DEBUG
            customHeaders["Accept-Encoding"] = "gzip, deflate"
            #endif
            GitHubAPI.GitHubAPIAPI.customHeaders = customHeaders
        }

        do { // Appearance settings
            let barButtonItemAppearance = UIBarButtonItem.appearance()
            barButtonItemAppearance.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
            barButtonItemAppearance.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = appMain.router.rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        dispatch(GlobalState.Action.changeApplicationState(appState: .willResignActive))
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        dispatch(GlobalState.Action.changeApplicationState(appState: .didEnterBackground))
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        dispatch(GlobalState.Action.changeApplicationState(appState: .willEnterForeground))
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        dispatch(GlobalState.Action.changeApplicationState(appState: .didBecomeActive))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        dispatch(GlobalState.Action.changeApplicationState(appState: .willTerminate))
    }

    private func dispatch(_ action: ReSwift.Action) {
        appMain.reduxStore.dispatch(action)
    }
}
