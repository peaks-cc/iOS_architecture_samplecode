//
//  GitHubApiSession.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

protocol GitHubApiRequestable: class {
    func searchRepositories(query: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ())
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()

    private let session = GitHub.Session()

    func searchRepositories(query: String, page: Int, completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ()) {
        let request = SearchRepositoriesRequest(query: query, sort: .stars, order: .desc, page: page, perPage: nil)
        session.send(request) { result in
            switch result {
            case let .success(response, pagination):
                completion(.success((response.items, pagination)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
