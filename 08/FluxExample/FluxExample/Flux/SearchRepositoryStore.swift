//
//  SearchRepositoryStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class SearchRepositoryStore: Store {
    static let shared = SearchRepositoryStore(dispatcher: .shared)

    private(set) var query: String?
    private(set) var pagination: GitHub.Pagination?
    private(set) var isSearchFieldEditing = false
    private(set) var isFetching = false
    private(set) var error: Error?

    private(set) var repositories: [GitHub.Repository] = []

    override func onDispatch(_ action: Action) {
        switch action {
        case let .searchRepositories(repositories):
            self.repositories.append(contentsOf: repositories)

        case .clearSearchRepositories:
            self.repositories.removeAll()

        case let .searchPagination(pagination):
            self.pagination = pagination

        case let .isRepositoriesFetching(isFetching):
            self.isFetching = isFetching

        case let .isSearchFieldEditing(isEditing):
            self.isSearchFieldEditing = isEditing

        case let .error(e):
            self.error = e

        case let .searchQuery(query):
            self.query = query

        case .selectedRepository,
             .setFavoriteRepositories:
            return

        }
        emitChange()
    }
}

