//
//  GithubRepositoryStore.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class GithubRepositoryStore: Store {
    static let shared = GithubRepositoryStore()

    private(set) var repositories: [Github.Repository] = []
    private(set) var selectedRepository: Github.Repository?

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

        case .addUsers,
             .clearUsers,
             .userSelected,
             .userUnselected,
             .isSeachUsersFieldEditing:
            return
        }
        emitChange()
    }
}
