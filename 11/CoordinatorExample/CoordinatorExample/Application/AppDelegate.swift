import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let type: AppCoordinator.LaunchType = .openURL(url)
        let appCoordinator = AppCoordinator(window: window,
                                            launchType: type)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let type: AppCoordinator.LaunchType = .userActivity(userActivity)
        let appCoordinator = AppCoordinator(window: window,
                                            launchType: type)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        return true
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let type: AppCoordinator.LaunchType = .shortcutItem(shortcutItem)
        let appCoordinator = AppCoordinator(window: window,
                                            launchType: type)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        completionHandler(true)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler
        completionHandler: @escaping () -> Void) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let request = response.notification.request
        let launchType: AppCoordinator.LaunchType = .notification(request)

        let appCoordinator = AppCoordinator(window: window,
                                            launchType: launchType)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        completionHandler()
    }
}
