//
//  ActionCreator.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

final class ActionCreator {
    
    private let dispatcher: Dispatcher
    private let apiSession: GithubApiRequestable

    init(dispatcher: Dispatcher = .shared,
         apiSession: GithubApiRequestable = Github.ApiSession.shared) {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
    }
}

// MARK: - Github.User

extension ActionCreator {
    func searchUsers(query: String) {
        apiSession.searchUsers(query: query) { [dispatcher] result in
            switch result {
            case let .success(users):
                dispatcher.dispatch(.addUsers(users))
            case let .failure(error):
                break
            }
        }
    }

    func setSelectedUser(_ user: Github.User?) {
        if let user = user {
            dispatcher.dispatch(.userSelected(user))
        } else {
            dispatcher.dispatch(.userUnselected)
        }
    }

    func setIsSearchUsersFieldEditing(_ isEditing: Bool) {
        dispatcher.dispatch(.isSeachUsersFieldEditing(isEditing))
    }
}

// MARK: Github.Repository

extension ActionCreator {
    func fetchRepositories(username: String) {
        apiSession.repositories(username: username) { [dispatcher] result in
            switch result {
            case let .success(repositories):
                dispatcher.dispatch(.addRepositories(repositories))
            case let .failure(error):
                break
            }
        }
    }

    func setSelectedRepository(_ repository: Github.Repository?) {
        if let repository = repository {
            dispatcher.dispatch(.repositorySelected(repository))
        } else {
            dispatcher.dispatch(.repositoryUnselected)
        }
    }
}
