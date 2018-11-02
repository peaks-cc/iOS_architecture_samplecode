//
//  SearchNavigationController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/10/23.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

// 画面遷移を検知し、表示するViewControllerに対してPresenterをInjectします
class SearchNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    private func injectPresenter(into viewController: UIViewController) {
        if let vc = viewController as? ReposPresenterInjectable {
            vc.inject(reposPresenter: Application.shared.reposPresenter)
        }
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {

        // タブの選択後、ナビゲーションここでViewControllerに依存性を注入
        // ※ このタイミングで注入する場合、VCにはviewWillAppear(_:)までPresenterが
        //   injectされません。しかし本サンプルプログラムではそのままにしています。
        injectPresenter(into: viewController)
    }
}
