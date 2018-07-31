//
//  AppDelegate.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/30.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var logic = Logic(window: self.window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return logic.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    final class Logic {
        let window: () -> UIWindow?

        private let actionCreator: ActionCreator
        private let repositoryStore: GithubRepositoryStore
        private let userStore: GithubUserStore

        init(window: @escaping @autoclosure () -> UIWindow?,
             actionCreator: ActionCreator = .init(),
             repositoryStore: GithubRepositoryStore = .shared,
             userStore: GithubUserStore = .shared) {
            self.window = window
            self.actionCreator = actionCreator
            self.repositoryStore = repositoryStore
            self.userStore = userStore
        }
    }
}

protocol ApplicationProtocol {}

extension UIApplication: ApplicationProtocol {}

extension AppDelegate.Logic {
    func application(_ application: ApplicationProtocol, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window()?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarSystemItem)] = [
                (UINavigationController(rootViewController: SearchUsersViewController()), .search),
                (UINavigationController(rootViewController: FavoritesViewController()), .favorites)
            ]
            values.enumerated().forEach {
                $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
            }
            tabBarController.setViewControllers(values.map { $0.0 }, animated: false)
        }

        actionCreator.loadFavoriteRepositories()

        return true
    }
}
