//
//  SelectedRepositoryStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class SelectedRepositoryStore: Store {
    static let shared = SelectedRepositoryStore(dispatcher: .shared)

    private(set) var repository: GitHub.Repository?

    override func onDispatch(_ action: Action) {
        switch action {
        case let .selectedRepository(repository):
            self.repository = repository

        case .searchRepositories,
             .clearSearchRepositories,
             .searchPagination,
             .isRepositoriesFetching,
             .isSearchFieldEditing,
             .error,
             .searchQuery,
             .setFavoriteRepositories:
            return
        }
        emitChange()
    }
}

