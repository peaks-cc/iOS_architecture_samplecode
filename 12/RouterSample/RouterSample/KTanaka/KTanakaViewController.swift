//
//  KTanakaViewController.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/10/19.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

class KTanakaViewController: UIViewController {
    private var presenter: KTanakaPresenter!
    func inject(presenter: KTanakaPresenter) {
        self.presenter = presenter
    }
}
