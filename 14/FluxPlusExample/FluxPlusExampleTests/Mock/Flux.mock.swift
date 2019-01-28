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
        let searchRepositoryDispatcher = SearchRepositoryDispatcher()
        let searchRepositoryActionCreator = SearchRepositoryActionCreator(dispatcher: searchRepositoryDispatcher,
                                                                          apiSession: apiSession)
        let searchRepositoryStore = SearchRepositoryStore(dispatcher: searchRepositoryDispatcher)

        let selectedRepositoryDispatcher = SelectedRepositoryDispatcher()
        let selectedRepositoryActionCreator = SelectedRepositoryActionCreator(dispatcher: selectedRepositoryDispatcher)
        let selectedRepositoryStore = SelectedRepositoryStore(dispatcher: selectedRepositoryDispatcher)

        let favoriteRepositoryDispatcher = FavoriteRepositoryDispatcher()
        let favoriteRepositoryActionCreator = FavoriteRepositoryActionCreator(dispatcher: favoriteRepositoryDispatcher,
                                                                              localCache: localCache)
        let favoriteRepositoryStore = FavoriteRepositoryStore(dispatcher: favoriteRepositoryDispatcher)

        return Flux(searchRepositoryDispatcher: searchRepositoryDispatcher,
                    searchRepositoryActionCreator: searchRepositoryActionCreator,
                    searchRepositoryStore: searchRepositoryStore,

                    selectedRepositoryDispatcher: selectedRepositoryDispatcher,
                    selectedRepositoryActionCreator: selectedRepositoryActionCreator,
                    selectedRepositoryStore: selectedRepositoryStore,

                    favoriteRepositoryDispatcher: favoriteRepositoryDispatcher,
                    favoriteRepositoryActionCreator: favoriteRepositoryActionCreator,
                    favoriteRepositoryStore: favoriteRepositoryStore)
    }
}
