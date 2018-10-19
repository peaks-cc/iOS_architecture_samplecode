//
//  SpySearchUserView.swift
//  RouterSampleTests
//
//  Created by Kenji Tanaka on 2018/10/19.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
@testable import RouterSample

class SpySearchUserView: UIViewController, SearchUserViewProtocol {
    var viewController: UIViewController!

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.viewController = viewController
    }

    func reloadTableView() {
        // 省略
    }
}
