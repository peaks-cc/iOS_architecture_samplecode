//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation

protocol RepositoryDetailPresenterProtocol {
    func viewDidLoad()
}

class RepositoryDetailPresenter: RepositoryDetailPresenterProtocol {
    private var model: RepositoryDetailModelProtocol

    private let userName: String
    private let repositoryName: String

    init(userName: String, repositoryName: String, model: RepositoryDetailModelProtocol) {
        self.userName = userName
        self.repositoryName = repositoryName
        self.model = model
    }

    func viewDidLoad() {
        model.fetchRepository()
    }
}