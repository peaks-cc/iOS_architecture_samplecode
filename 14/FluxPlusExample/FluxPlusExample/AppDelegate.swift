//
//  AppDelegate.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var handler = _AppDelegate(window: window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return handler.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

protocol ApplicationProtocol {}

extension UIApplication: ApplicationProtocol {}

final class _AppDelegate {

    private let window: UIWindow?
    private let flux: Flux

    private lazy var showRepositoryDetailDisposable: Disposable = {
        return flux.selectedRepositoryStore.repository.asObservable()
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

    init(window: UIWindow?, flux: Flux = .shared) {
        self.window = window
        self.flux = flux
    }

    func application(_ application: ApplicationProtocol, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
            flux.favoriteRepositoryActionCreator.loadFavoriteRepositories()
        }

        return true
    }
}
