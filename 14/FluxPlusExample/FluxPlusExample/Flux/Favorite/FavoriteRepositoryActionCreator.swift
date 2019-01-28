//
//  FavoriteRepositoryActionCreator.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class FavoriteRepositoryActionCreator {

    static let shared = FavoriteRepositoryActionCreator()

    private let dispatcher: FavoriteRepositoryDispatcher
    private let localCache: LocalCacheable

    init(dispatcher: FavoriteRepositoryDispatcher = .shared,
         localCache: LocalCacheable = LocalCache.shared) {
        self.dispatcher = dispatcher
        self.localCache = localCache
    }

    func addFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites] + [repository]
        localCache[.favorites] = repositories
        dispatcher.repositories.accept(repositories)
    }

    func removeFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites].filter { $0.id != repository.id }
        localCache[.favorites] = repositories
        dispatcher.repositories.accept(repositories)
    }

    func loadFavoriteRepositories() {
        dispatcher.repositories.accept(localCache[.favorites])
    }
}
