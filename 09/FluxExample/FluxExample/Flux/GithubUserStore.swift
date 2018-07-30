//
//  GithubUserStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class GithubUserStore: Store {
    static let shared = GithubUserStore()

    private(set) var users: [Github.User] = []
    private(set) var selectedUser: Github.User?
    private(set) var isSeachUsersFieldEditing = false

    override init(dispatcher: Dispatcher = .shared) {
        super.init(dispatcher: dispatcher)
    }

    override func onDispatch(_ action: Action) {
        switch action {
        case let .addUsers(users):
            self.users = self.users + users
        case .clearUsers:
            self.users.removeAll()
        case let .userSelected(user):
            self.selectedUser = user
        case .userUnselected:
            self.selectedUser = nil
        case .isSeachUsersFieldEditing(let isEditing):
            self.isSeachUsersFieldEditing = isEditing

        case .addRepositories,
             .clearRepositories,
             .repositorySelected,
             .repositoryUnselected:
            return
        }
        emitChange()
    }
}
