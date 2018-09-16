//
//  MockGitHubApiSession.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
@testable import FluxPlusExample

final class MockGitHubApiSession: GitHubApiRequestable {

    let searchRepositoriesParams: Observable<(String, Int)>
    private let _searchRepositoriesParams = PublishRelay<(String, Int)>()
    private let _searchRepositoriesResult = PublishRelay<([GitHub.Repository], GitHub.Pagination)>()


    init() {
        self.searchRepositoriesParams = _searchRepositoriesParams.asObservable()
    }

    func searchRepositories(query: String, page: Int) -> Observable<([Repository], Pagination)> {
        _searchRepositoriesParams.accept((query, page))
        return _searchRepositoriesResult.asObservable()
    }

    func setSearchRepositoriesResult(repositories: [GitHub.Repository], pagination: GitHub.Pagination) {
        _searchRepositoriesResult.accept((repositories, pagination))
    }
}
