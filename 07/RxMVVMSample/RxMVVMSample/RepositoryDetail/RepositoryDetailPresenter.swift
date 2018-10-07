//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import GitHub

protocol RepositoryDetailPresenterProtocol {
    func viewDidLoad()
}

class RepositoryDetailPresenter: RepositoryDetailPresenterProtocol {
    private var model: RepositoryDetailModelProtocol

    private let userName: GitHub.User.Name
    private let repositoryName: GitHub.Repository.Name

    init(userName: GitHub.User.Name, repositoryName: GitHub.Repository.Name, model: RepositoryDetailModelProtocol) {
        self.userName = userName
        self.repositoryName = repositoryName
        self.model = model
    }

    func viewDidLoad() {
        model.fetchRepository()
    }
}
