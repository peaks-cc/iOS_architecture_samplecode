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
        _ = apiSession.searchUsers(query: query, page: page)
            .take(1)
            .subscribe(onNext: { [dispatcher] users, pagination in
                dispatcher.addUsers.accept(users)
                dispatcher.pagination.accept(pagination)
                dispatcher.isFetching.accept(false)
            }, onError: { [dispatcher] error in
                dispatcher.error.accept(error)
                dispatcher.isFetching.accept(false)
            })
    }

    func setSelectedUser(_ user: GitHub.User?) {
        dispatcher.selectedUser.accept(user)
    }

    func setIsSearchUsersFieldEditing(_ isEditing: Bool) {
        dispatcher.isFieldEditing.accept(isEditing)
    }

    func clearUsers() {
        dispatcher.clearUsers.accept(())
    }
}
