//
//  FavoriteRepositoryStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class FavoriteRepositoryStore: Store {
    static let shared = FavoriteRepositoryStore(dispatcher: .shared)

    private(set) var repositories: [GitHub.Repository] = []

    override func onDispatch(_ action: Action) {
        switch action {
        case let .setFavoriteRepositories(repositories):
            self.repositories = repositories

        case .selectedRepository,
             .searchRepositories,
             .clearSearchRepositories,
             .searchPagination,
             .isRepositoriesFetching,
             .isSearchFieldEditing,
             .searchQuery,
             .error:
            return

        }
        emitChange()
    }
}

