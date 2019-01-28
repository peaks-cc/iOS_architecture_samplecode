//
//  AppDelegate.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let actionCreator = ActionCreator()
    private let selectedRepositoryStore: SelectedRepositoryStore = .shared
    private let favoriteRepositoryStore: FavoriteRepositoryStore = .shared
    private let searchRepositoryStore: SearchRepositoryStore = .shared

    private lazy var showRepositoryDetailDisposable: Disposable = {
        return selectedRepositoryStore.repositoryObservable
            .flatMap { $0 == nil ? .empty() : Observable.just(()) }
            .bind(to: Binder(self) { me, _ in
                guard
                    let tabBarController = me.window?.rootViewController as? UITabBarController,
                    let navigationController = tabBarController.selectedViewController as? UINavigationController
                else {
                    return
                }
                let vc = RepositoryDetailViewController()
                navigationController.pushViewController(vc, animated: true)
            })
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarItem.SystemItem)] = [
                (UINavigationController(rootViewController: RepositorySearchViewController()), .search),
                (UINavigationController(rootViewController: FavoritesViewController()), .favorites)
            ]
            values.enumerated().forEach {
                $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
            }
            tabBarController.setViewControllers(values.map { $0.0 }, animated: false)

            _ = showRepositoryDetailDisposable
            actionCreator.loadFavoriteRepositories()
        }

        return true
    }
}

