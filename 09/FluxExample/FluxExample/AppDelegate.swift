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

    private let actionCreator = ActionCreator()
    private let searchStore = SearchRepositoryStore.shared
    private let favoriteStore = FavoriteRepositoryStore.shared
    private let selectedStore = SelectedRepositoryStore.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarSystemItem)] = [
                (UINavigationController(rootViewController: RepositorySearchViewController()), .search),
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
