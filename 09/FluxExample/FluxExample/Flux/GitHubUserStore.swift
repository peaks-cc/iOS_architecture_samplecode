//
//  GitHubUserStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class GitHubUserStore: Store {
    static let shared = GitHubUserStore(dispatcher: .shared)

    private(set) var users: [GitHub.User] = []
    private(set) var pagination: GitHub.Pagination?
    private(set) var isFetching = false
    private(set) var query: String?
    private(set) var selectedUser: GitHub.User?
    private(set) var isSeachUsersFieldEditing = false
    private(set) var error: Error?

    override func onDispatch(_ action: Action) {
        switch action {
        case let .addUsers(users):
            self.users.append(contentsOf: users)
        case .clearUsers:
            self.users.removeAll()
        case let .userSelected(user):
            self.selectedUser = user
        case .userUnselected:
            self.selectedUser = nil
        case let .isSeachUsersFieldEditing(isEditing):
            self.isSeachUsersFieldEditing = isEditing
        case let .searchUsersPagination(pagination):
            self.pagination = pagination
        case .clearSearchUsersPagination:
            self.pagination = nil
        case let .isSearchUsersFetching(isFetching):
            self.isFetching = isFetching
        case let .searchQuery(query):
            self.query = query
        case .clearSearchQuery:
            self.query = nil

        case let .error(e):
            self.error = e
        case .clearError:
            self.error = nil

        case .addRepositories,
             .clearRepositories,
             .repositorySelected,
             .repositoryUnselected,
             .loadFavoriteRepositories,
             .repositoriesPagination,
             .clearRepositoriesPagination,
             .isUserRepositoriesFetching:
            return
        }
        emitChange()
    }
}
