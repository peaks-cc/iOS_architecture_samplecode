//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit

protocol UserDetailRouterProtocol: class {
    func transitionToRepositoryDetail(userName: String, repositoryName: String)
}

class UserDetailRouter: UserDetailRouterProtocol {
    private weak var view: UserDetailViewProtocol!

    init(view: UserDetailViewProtocol) {
        self.view = view
    }

    func transitionToRepositoryDetail(userName: String, repositoryName: String) {
        let model = RepositoryDetailModel(userName: userName, repositoryName: repositoryName)
        let presenter = RepositoryDetailPresenter(userName: userName, repositoryName: repositoryName, model: model)
        let repositoryDetailVC = UIStoryboard(name: "RepositoryDetail", bundle: nil).instantiateInitialViewController() as! RepositoryDetailViewController
        repositoryDetailVC.inject(presenter: presenter)

        view.push(repositoryDetailVC, animated: true)
    }
}
