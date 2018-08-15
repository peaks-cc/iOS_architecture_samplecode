//
//  AppDelegate.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var logic = AppDelegateLogic(window: window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return logic.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

protocol ApplicationProtocol {}

extension UIApplication: ApplicationProtocol {}

final class AppDelegateLogic {

    private let window: UIWindow?
    private let flux: Flux

    init(window: UIWindow?, flux: Flux = .shared) {
        self.window = window
        self.flux = flux
    }

    func application(_ application: ApplicationProtocol, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarSystemItem)] = [
                (UINavigationController(rootViewController: SearchUsersViewController()), .search),
                (UINavigationController(rootViewController: FavoritesViewController()), .favorites)
            ]
            values.enumerated().forEach {
                $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
            }
            tabBarController.setViewControllers(values.map { $0.0 }, animated: false)

            flux.repositoryActionCreator.loadFavoriteRepositories()
        }

        return true
    }
}

