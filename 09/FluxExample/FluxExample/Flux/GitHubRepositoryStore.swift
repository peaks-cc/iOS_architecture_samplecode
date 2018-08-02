//
//  GitHubRepositoryStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class GitHubRepositoryStore: Store {
    static let shared = GitHubRepositoryStore()

    private(set) var repositories: [GitHub.Repository] = []
    private(set) var pagination: GitHub.Pagination?
    private(set) var selectedRepository: GitHub.Repository?
    private(set) var favorites: [GitHub.Repository] = []
    private(set) var selectedFavoriteRepository: GitHub.Repository?
    private(set) var error: Error?

    override init(dispatcher: Dispatcher = .shared) {
        super.init(dispatcher: dispatcher)
    }

    override func onDispatch(_ action: Action) {
        switch action {
        case let .addRepositories(repositories):
            self.repositories = self.repositories + repositories
        case .clearRepositories:
            self.repositories.removeAll()
        case let .repositorySelected(repository):
            self.selectedRepository = repository
        case .repositoryUnselected:
            self.selectedRepository = nil
        case let .loadFavoriteRepositories(repositories):
            self.favorites = repositories
        case let .repositoriesPagination(pagination):
            self.pagination = pagination
        case .clearRepositoriesPagination:
            self.pagination = nil

        case let .error(e):
            self.error = e
        case .clearError:
            self.error = nil

        case .addUsers,
             .clearUsers,
             .userSelected,
             .userUnselected,
             .isSeachUsersFieldEditing,
             .searchUsersPagination,
             .clearSearchUsersPagination,
             .isSearchUsersFetching,
             .searchQuery,
             .clearSearchQuery:
            return
        }
        emitChange()
    }
}
