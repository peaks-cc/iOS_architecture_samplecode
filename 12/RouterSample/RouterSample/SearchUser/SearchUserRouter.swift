//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
import GitHub

protocol SearchUserRouterProtocol {
    func transitionToUserDetail(userName: String)
}

class SearchUserRouter: SearchUserRouterProtocol {
    private(set) weak var view: SearchUserViewProtocol!

    init(view: SearchUserViewProtocol) {
        self.view = view
    }

    func transitionToUserDetail(userName: String) {
        let userDetailVC = UIStoryboard(name: "UserDetail", bundle: nil).instantiateInitialViewController() as! UserDetailViewController
        let model = UserDetailModel()
        let presenter = UserDetailPresenter(userName: userName, view: userDetailVC, model: model)
        userDetailVC.inject(presenter: presenter)

        // なんかいいかんじの制約をprotocolにかけられないものか🤔
        let searchUserVC = view as! SearchUserViewController
        view.push(from: searchUserVC, to: userDetailVC, animated: true)
    }
}
