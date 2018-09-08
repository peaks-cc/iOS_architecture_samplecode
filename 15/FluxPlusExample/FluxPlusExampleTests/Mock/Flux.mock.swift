//
//  Flux.mock.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import FluxPlusExample

extension Flux {
    static func mock(apiSession: MockGitHubApiSession = .init(),
                     localCache: MockLocalCache = .init()) -> Flux {
        let repositoryDispatcher = GitHubRepositoryDispatcher()
        let repositoryActionCreator = GitHubRepositoryActionCreator(dispatcher: repositoryDispatcher,
                                                                    apiSession: apiSession,
                                                                    localCache: localCache)
        let repositoryStore = GitHubRepositoryStore(dispatcher: repositoryDispatcher)

        let userDispatcher = GitHubUserDispatcher()
        let userActionCreator = GitHubUserActionCreator(dispatcher: userDispatcher,
                                                        apiSession: apiSession)
        let userStore = GitHubUserStore(dispatcher: userDispatcher)

        return Flux(repositoryDispatcher: repositoryDispatcher,
                    repositoryActionCreator: repositoryActionCreator,
                    repositoryStore: repositoryStore,
                    userDispatcher: userDispatcher,
                    userActionCreator: userActionCreator,
                    userStore: userStore)
    }
}
