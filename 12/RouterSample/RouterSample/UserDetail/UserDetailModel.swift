//
// Created by Kenji Tanaka on 2018/09/26.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation
import GitHub

protocol UserDetailModelProtocol {
    func fetchRepositories(completion: @escaping (Result<[Repository]>) -> ())
}

class UserDetailModel: UserDetailModelProtocol {
    private let userName: String!
    init(userName: String) {
        self.userName = userName
    }

    func fetchRepositories(completion: @escaping (Result<[Repository]>) -> ()) {
        let session = GitHub.Session()
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