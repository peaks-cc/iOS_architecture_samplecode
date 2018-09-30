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

    let searchRepositoriesParams: Observable<(String, Int)>
    private let _searchRepositoriesParams = PublishRelay<(String, Int)>()
    private let _searchRepositoriesResult = PublishRelay<([GitHub.Repository], GitHub.Pagination)>()

    private var searchRepositoriesDisposeBag: DisposeBag?

    init() {
        self.searchRepositoriesParams = _searchRepositoriesParams.asObservable()
    }

    func searchRepositories(query: String, page: Int, completion: @escaping (Result<([Repository], Pagination)>) -> ()) {
        _searchRepositoriesParams.accept((query, page))

        let disposeBag = DisposeBag()
        _searchRepositoriesResult
            .map { Result.success($0) }
            .subscribe(onNext: completion)
            .disposed(by: disposeBag)

        searchRepositoriesDisposeBag = disposeBag
    }

    func setSearchRepositoriesResult(repositories: [GitHub.Repository], pagination: GitHub.Pagination) {
        _searchRepositoriesResult.accept((repositories, pagination))
    }
}
