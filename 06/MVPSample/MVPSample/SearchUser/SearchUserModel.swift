//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation
import GitHub

protocol SearchUserModelInput {
    func fetchUser(
        query: String,
        completion: @escaping (Result<[User]>) -> ())
}

final class SearchUserModel: SearchUserModelInput {
    func fetchUser(
        query: String,
        completion: @escaping (Result<[User]>) -> ()) {

        let session = GitHub.Session()
        let request = SearchUsersRequest(
            query: query,
            sort: nil,
            order: nil,
            page: nil,
            perPage: nil)
        
        session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.0.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
