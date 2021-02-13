//
//  SearchRepositoryActionCreator.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class SearchRepositoryActionCreator {

    static let shared = SearchRepositoryActionCreator()

    private let dispatcher: SearchRepositoryDispatcher

    private let _searchRepositories = PublishRelay<(String, Int)>()
    private let disposeBag = DisposeBag()

    init(dispatcher: SearchRepositoryDispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared) {
        self.dispatcher = dispatcher

        let repositoriesAndPagination = _searchRepositories
            .flatMap { query, page -> Observable<GitHub.Result<([GitHub.Repository], GitHub.Pagination)>> in
                apiSession.searchRepositories(query: query, page: page)
                    .map { .success($0) }
                    .catch { .just(.failure($0)) }
            }
            .share()

        Observable.merge(repositoriesAndPagination.map { _ in false },
                         _searchRepositories.map { _ in true })
            .bind(to: dispatcher.isFetching)
            .disposed(by: disposeBag)

        repositoriesAndPagination
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: dispatcher.error)
            .disposed(by: disposeBag)

        let element = repositoriesAndPagination
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .share()

        element
            .map { $0.0 }
            .bind(to: dispatcher.addRepositories)
            .disposed(by: disposeBag)

        element
            .map { $0.1 }
            .bind(to: dispatcher.pagination)
            .disposed(by: disposeBag)

        _searchRepositories
            .map { $0.0 }
            .bind(to: dispatcher.query)
            .disposed(by: disposeBag)
    }

    func searchRepositories(query: String, page: Int = 1) {
        _searchRepositories.accept((query, page))
    }

    func setIsSearchFieldEditing(_ isEditing: Bool) {
        dispatcher.isSearchFieldEditing.accept(isEditing)
    }

    func clearRepositories() {
        dispatcher.clearRepositories.accept(())
    }
}
