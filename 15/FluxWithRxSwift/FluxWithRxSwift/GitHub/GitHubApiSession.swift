//
//  GitHubApiSession.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

protocol GitHubApiRequestable: class {
    func searchUsers(query: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.User], GitHub.Pagination)>) -> ())
    func repositories(username: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ())
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()

    private let session = GitHub.Session()

    func searchUsers(query: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.User], GitHub.Pagination)>) -> ()) {
        let request = SearchUsersRequest(query: query, sort: nil, order: nil, page: page, perPage: nil)
        session.send(request) { result in
            switch result {
            case let .success(response, pagination):
                completion(.success((response.items, pagination)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func repositories(username: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ()) {
        let request = UserReposRequest(username: username, type: nil, sort: nil, direction: nil, page: page, perPage: nil)
        session.send(request, completion: completion)
    }
}

