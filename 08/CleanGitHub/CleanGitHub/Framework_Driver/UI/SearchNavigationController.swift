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
}
