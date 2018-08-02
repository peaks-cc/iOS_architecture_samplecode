//
//  ActionCreator.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

final class ActionCreator {
    
    private let dispatcher: Dispatcher
    private let apiSession: GitHubApiRequestable
    private let localCache: LocalCacheable

    init(dispatcher: Dispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared,
         localCache: LocalCacheable = LocalCache.shared) {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
        self.localCache = localCache
    }
}

// MARK: - Github.User

extension ActionCreator {
    func searchUsers(query: String, page: Int = 1) {
        dispatcher.dispatch(.searchQuery(query))
        dispatcher.dispatch(.isSearchUsersFetching(true))
        apiSession.searchUsers(query: query, page: page) { [dispatcher] result in
            switch result {
            case let .success(users, pagination):
                dispatcher.dispatch(.addUsers(users))
                dispatcher.dispatch(.searchUsersPagination(pagination))
            case let .failure(error):
                dispatcher.dispatch(.error(error))
            }
            dispatcher.dispatch(.isSearchUsersFetching(false))
        }
    }

    func setSelectedUser(_ user: GitHub.User?) {
        if let user = user {
            dispatcher.dispatch(.userSelected(user))
        } else {
            dispatcher.dispatch(.userUnselected)
        }
    }

    func setIsSearchUsersFieldEditing(_ isEditing: Bool) {
        dispatcher.dispatch(.isSeachUsersFieldEditing(isEditing))
    }

    func clearUsers() {
        dispatcher.dispatch(.clearUsers)
    }
}

// MARK: Github.Repository

extension ActionCreator {
    func fetchRepositories(username: String,  page: Int = 1) {
        dispatcher.dispatch(.isUserRepositoriesFetching(true))
        apiSession.repositories(username: username, page: page) { [dispatcher] result in
            switch result {
            case let .success(repositories, pagination):
                dispatcher.dispatch(.addRepositories(repositories))
                dispatcher.dispatch(.repositoriesPagination(pagination))
            case let .failure(error):
                dispatcher.dispatch(.error(error))
            }
            dispatcher.dispatch(.isUserRepositoriesFetching(false))
        }
    }

    func clearRepositories() {
        dispatcher.dispatch(.clearRepositories)
    }

    func setSelectedRepository(_ repository: GitHub.Repository?) {
        if let repository = repository {
            dispatcher.dispatch(.repositorySelected(repository))
        } else {
            dispatcher.dispatch(.repositoryUnselected)
        }
    }

    func addFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites] + [repository]
        localCache[.favorites] = repositories
        dispatcher.dispatch(.loadFavoriteRepositories(repositories))
    }

    func removeFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites].filter { $0.id != repository.id }
        localCache[.favorites] = repositories
        dispatcher.dispatch(.loadFavoriteRepositories(repositories))
    }

    func loadFavoriteRepositories() {
        dispatcher.dispatch(.loadFavoriteRepositories(localCache[.favorites]))
    }
}
