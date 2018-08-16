//
//  MockGitHubApiSession.swift
//  FluxWithRxSwiftTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
@testable import FluxWithRxSwift

final class MockGitHubApiSession: GitHubApiRequestable {

    let searchUsersParams: Observable<(String, Int)>
    private let _searchUsersParams = PublishRelay<(String, Int)>()
    private let _searchUsersResult = PublishRelay<([GitHub.User], GitHub.Pagination)>()

    let repositoriesParams: Observable<(String, Int)>
    private let _repositoriesParams = PublishRelay<(String, Int)>()
    private let _repositoriesResult = PublishRelay<([GitHub.Repository], GitHub.Pagination)>()

    init() {
        self.searchUsersParams = _searchUsersParams.asObservable()
        self.repositoriesParams = _repositoriesParams.asObservable()
    }

    func setSearchUsersResult(users: [GitHub.User], pagination: GitHub.Pagination) {
        _searchUsersResult.accept((users, pagination))
    }

    func searchUsers(query: String, page: Int) -> Observable<([GitHub.User], GitHub.Pagination)> {
        _searchUsersParams.accept((query, page))
        return _searchUsersResult.asObservable()
    }

    func setRepositoriesResult(repositories: [GitHub.Repository], pagination: GitHub.Pagination) {
        _repositoriesResult.accept((repositories, pagination))
    }

    func repositories(username: String, page: Int) -> Observable<([GitHub.Repository], GitHub.Pagination)> {
        _repositoriesParams.accept((username, page))
        return _repositoriesResult.asObservable()
    }
}
