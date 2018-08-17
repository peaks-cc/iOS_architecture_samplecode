//
//  MockGitHubApiSession.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/04.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
@testable import FluxExample

final class MockGitHubApiSession: GitHubApiRequestable {
    struct NoResultError: Error {}

    var searchUsersResult: Result<([User], Pagination)>?
    var searchUsersParams: ((String, Int) -> ())?

    var repositoriesResult: Result<([Repository], Pagination)>?
    var repositoriesParams: ((String, Int) -> ())?

    func searchUsers(query: String, page: Int, completion: @escaping (Result<([User], Pagination)>) -> ()) {
        searchUsersParams?(query, page)
        completion(searchUsersResult ?? .failure(NoResultError()))
    }

    func repositories(username: String, page: Int, completion: @escaping (Result<([Repository], Pagination)>) -> ()) {
        repositoriesParams?(username, page)
        completion(repositoriesResult ?? .failure(NoResultError()))
    }
}
