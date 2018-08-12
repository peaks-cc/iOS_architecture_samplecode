//
//  GitHubUserActionCreator.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class GitHubUserActionCreator {
    static let shared = GitHubUserActionCreator()

    private let dispatcher: GitHubUserDispatcher
    private let apiSession: GitHubApiRequestable

    init(dispatcher: GitHubUserDispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared) {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
    }

    func searchUsers(query: String, page: Int = 1) {
        dispatcher.searchQuery.accept(query)
        dispatcher.isFetching.accept(true)
        apiSession.searchUsers(query: query, page: page) { [dispatcher] result in
            switch result {
            case let .success(users, pagination):
                dispatcher.addUsers.accept(users)
                dispatcher.pagination.accept(pagination)
            case let .failure(error):
                dispatcher.error.accept(error)
            }
            dispatcher.isFetching.accept(false)
        }
    }

    func setSelectedUser(_ user: GitHub.User?) {
        if let user = user {
            dispatcher.selectedUser.accept(user)
        } else {
            dispatcher.selectedUser.accept(nil)
        }
    }

    func setIsSearchUsersFieldEditing(_ isEditing: Bool) {
        dispatcher.isFieldEditing.accept(isEditing)
    }

    func clearUsers() {
        dispatcher.clearUsers.accept(())
    }
}
