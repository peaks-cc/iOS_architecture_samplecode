//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation

protocol RepositoryDetailModelProtocol {
    func fetchRepository()
}

class RepositoryDetailModel: RepositoryDetailModelProtocol {
    func fetchRepository() {
        let session = GitHub.Session()
        let
        let request = UserReposRequest(username: userName, type: nil, sort: nil, direction: nil, page: nil, perPage: nil)
        session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.0))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
