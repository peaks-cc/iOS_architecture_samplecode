//
//  SearchRepositoryStore.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SearchRepositoryStore {
    static let shared = SearchRepositoryStore()

    private let _query = BehaviorRelay<String?>(value: nil)
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)
    private let _isSearchFieldEditing = BehaviorRelay<Bool>(value: false)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _repositories = BehaviorRelay<[GitHub.Repository]>(value: [])

    let error: Observable<Error>

    private let disposeBag = DisposeBag()

    init(dispatcher: SearchRepositoryDispatcher = .shared) {
        self.error = dispatcher.error.asObservable()

        dispatcher.query
            .bind(to: _query)
            .disposed(by: disposeBag)

        dispatcher.pagination
            .bind(to: _pagination)
            .disposed(by: disposeBag)

        dispatcher.addRepositories
            .withLatestFrom(_repositories) { $1 + $0 }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.clearRepositories
            .map { [] }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.isSearchFieldEditing
            .bind(to: _isSearchFieldEditing)
            .disposed(by: disposeBag)

        dispatcher.isFetching
            .bind(to: _isFetching)
            .disposed(by: disposeBag)
    }
}

// MARK: - Values

extension SearchRepositoryStore {
    var repositories: [GitHub.Repository] {
        return _repositories.value
    }
    var pagination: GitHub.Pagination? {
        return _pagination.value
    }
    var isSearchFieldEditing: Bool {
        return _isSearchFieldEditing.value
    }
    var isFetching: Bool {
        return _isFetching.value
    }
    var query: String? {
        return _query.value
    }
}

// MARK: - Observables

extension SearchRepositoryStore {
    var repositoriesObservable: Observable<[GitHub.Repository]> {
        return _repositories.asObservable()
    }
    var paginationObservable: Observable<GitHub.Pagination?> {
        return _pagination.asObservable()
    }
    var isSearchFieldEditingObservable: Observable<Bool> {
        return _isSearchFieldEditing.asObservable()
    }
    var isFetchingObservable: Observable<Bool> {
        return _isFetching.asObservable()
    }
    var queryObservable: Observable<String?> {
        return _query.asObservable()
    }
}
