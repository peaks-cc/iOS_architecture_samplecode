//
//  TabBarController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/11/02.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func awakeFromNib() {
        let useCase: ReposLikesUseCase! = Application.shared.useCase

        // -- Interface adapters
        let reposPresenter = ReposPresenter(useCase: useCase)

        useCase.output = reposPresenter

        // PresenterをView Controllerに注入
        inject(presenter: reposPresenter)
    }

    private func inject(presenter: ReposPresenterProtocol) {
        viewControllers?.forEach { vc in
            inject(presenter: presenter, into: vc)
        }
    }

    private func inject(presenter: ReposPresenterProtocol, into vc: UIViewController) {
        switch vc {
        case let injectable as ReposPresenterInjectable:
            injectable.inject(reposPresenter: presenter)
        case let navVC as UINavigationController:
            if let topVC = navVC.topViewController {
                inject(presenter: presenter, into: topVC)
            }
        default: break
        }

    }
}
