//
//  Flux.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/14.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

final class Flux {
    static let shared = Flux()

    let repositoryDispatcher: GitHubRepositoryDispatcher
    let repositoryActionCreator: GitHubRepositoryActionCreator
    let repositoryStore: GitHubRepositoryStore

    let userDispatcher: GitHubUserDispatcher
    let userActionCreator: GitHubUserActionCreator
    let userStore: GitHubUserStore

    init(repositoryDispatcher: GitHubRepositoryDispatcher = .shared,
         repositoryActionCreator: GitHubRepositoryActionCreator = .shared,
         repositoryStore: GitHubRepositoryStore = .shared,
         userDispatcher: GitHubUserDispatcher = .shared,
         userActionCreator: GitHubUserActionCreator = .shared,
         userStore: GitHubUserStore = .shared) {
        self.repositoryDispatcher = repositoryDispatcher
        self.repositoryActionCreator = repositoryActionCreator
        self.repositoryStore = repositoryStore
        self.userDispatcher = userDispatcher
        self.userActionCreator = userActionCreator
        self.userStore = userStore
    }
}
