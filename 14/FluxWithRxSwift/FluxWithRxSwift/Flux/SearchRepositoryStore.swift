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

    private let _error = PublishRelay<Error>()

    private let disposeBag = DisposeBag()

    init(dispatcher: Dispatcher = .shared) {

        dispatcher.register(callback: { [weak self] action in
            guard let me = self else {
                return
            }

            switch action {
            case let .searchRepositories(repositories):
                me._repositories.accept(me._repositories.value + repositories)

            case .clearSearchRepositories:
                me._repositories.accept([])

            case let .searchPagination(pagination):
                me._pagination.accept(pagination)

            case let .isRepositoriesFetching(isFetching):
                me._isFetching.accept(isFetching)

            case let .isSearchFieldEditing(isEditing):
                me._isSearchFieldEditing.accept(isEditing)

            case let .error(error):
                me._error.accept(error)

            case let .searchQuery(query):
                me._query.accept(query)

            case .selectedRepository,
                 .setFavoriteRepositories:
                return

            }
        })
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

    var errorObservable: Observable<Error> {
        return _error.asObservable()
    }
}
