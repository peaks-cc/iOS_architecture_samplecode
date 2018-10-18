//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
import GitHub

protocol SearchUserRouterProtocol: class {
    func transitionToUserDetail(userName: String)
}

class SearchUserRouter: SearchUserRouterProtocol {
    private(set) weak var view: SearchUserViewProtocol!

    init(view: SearchUserViewProtocol) {
        self.view = view
    }

    func transitionToUserDetail(userName: String) {
        if userName == "ktanaka117" {
            let kTanakaVC = UIStoryboard(name: "KTanaka", bundle: nil)
                .instantiateInitialViewController() as! KTanakaViewController
            let model = KTanakaModel()
            let router = KTanakaRouter()
            let presenter = KTanakaPresenter(
                model: model,
                router: router)
            kTanakaVC.inject(presenter: presenter)

            view.pushViewController(kTanakaVC, animated: true)
        } else {
            let userDetailVC = UIStoryboard(name: "UserDetail", bundle: nil)
                .instantiateInitialViewController() as! UserDetailViewController
            let model = UserDetailModel(userName: userName)
            let presenter = UserDetailPresenter(
                userName: userName,
                view: userDetailVC,
                model: model)
            userDetailVC.inject(presenter: presenter)

            view.pushViewController(userDetailVC, animated: true)
        }
    }
}
