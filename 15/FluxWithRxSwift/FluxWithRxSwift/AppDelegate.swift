//
//  AppDelegate.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let repositoryActionCreator = GitHubRepositoryActionCreator.shared
    private let repositoryStore = GitHubRepositoryStore.shared
    private let userActionCreator = GitHubUserActionCreator.shared
    private let userStore = GitHubUserStore.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let tabBarController = window?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarSystemItem)] = [
                (UINavigationController(rootViewController: SearchUsersViewController()), .search),
                (UINavigationController(rootViewController: FavoritesViewController()), .favorites)
            ]
            values.enumerated().forEach {
                $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
            }
            tabBarController.setViewControllers(values.map { $0.0 }, animated: false)
        }

        repositoryActionCreator.loadFavoriteRepositories()

        return true
    }
}

