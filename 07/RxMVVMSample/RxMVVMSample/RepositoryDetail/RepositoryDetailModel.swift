//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import GitHub

// fetchRepository
// fetchContributors

protocol RepositoryDetailModelProtocol {
    func fetchRepository()
}

class RepositoryDetailModel: RepositoryDetailModelProtocol {
    private let userName: GitHub.User.Name
    private let repositoryName: GitHub.Repository.Name

    init(userName: GitHub.User.Name, repositoryName: GitHub.Repository.Name) {
        self.userName = userName
        self.repositoryName = repositoryName
    }

    func fetchRepository() {
//        let session = GitHub.Session()
//        let request
//        session.send(request) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.0))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
