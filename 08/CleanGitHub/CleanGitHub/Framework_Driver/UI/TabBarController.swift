//
//  TabBarController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/11/02.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, PresentersInjectable {

    func inject(presenters: [ReposPresenterProtocol]) {
        presenters.forEach { presenter in
            viewControllers?.forEach { vc in
                switch vc {
                case let injectable as ReposPresenterInjectable:
                    injectable.inject(reposPresenter: presenter)
                case let navVC as UINavigationController:
                    if let injectable = navVC.topViewController as? ReposPresenterInjectable {
                        injectable.inject(reposPresenter: presenter)
                    }
                default: break
                }
            }
        }
    }
}
