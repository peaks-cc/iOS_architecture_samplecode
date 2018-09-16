//
//  Flux.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/14.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

final class Flux {
    static let shared = Flux()

    let searchRepositoryDispatcher: SearchRepositoryDispatcher
    let searchRepositoryActionCreator: SearchRepositoryActionCreator
    let searchRepositoryStore: SearchRepositoryStore

    let selectedRepositoryDispatcher: SelectedRepositoryDispatcher
    let selectedRepositoryActionCreator: SelectedRepositoryActionCreator
    let selectedRepositoryStore: SelectedRepositoryStore

    let favoriteRepositoryDispatcher: FavoriteRepositoryDispatcher
    let favoriteRepositoryActionCreator: FavoriteRepositoryActionCreator
    let favoriteRepositoryStore: FavoriteRepositoryStore

    init(searchRepositoryDispatcher: SearchRepositoryDispatcher = .shared,
         searchRepositoryActionCreator: SearchRepositoryActionCreator = .shared,
         searchRepositoryStore: SearchRepositoryStore = .shared,
         selectedRepositoryDispatcher: SelectedRepositoryDispatcher = .shared,
         selectedRepositoryActionCreator: SelectedRepositoryActionCreator = .shared,
         selectedRepositoryStore: SelectedRepositoryStore = .shared,
         favoriteRepositoryDispatcher: FavoriteRepositoryDispatcher = .shared,
         favoriteRepositoryActionCreator: FavoriteRepositoryActionCreator = .shared,
         favoriteRepositoryStore: FavoriteRepositoryStore = .shared) {
        self.searchRepositoryDispatcher = searchRepositoryDispatcher
        self.searchRepositoryActionCreator = searchRepositoryActionCreator
        self.searchRepositoryStore = searchRepositoryStore

        self.selectedRepositoryDispatcher = selectedRepositoryDispatcher
        self.selectedRepositoryActionCreator = selectedRepositoryActionCreator
        self.selectedRepositoryStore = selectedRepositoryStore

        self.favoriteRepositoryDispatcher = favoriteRepositoryDispatcher
        self.favoriteRepositoryActionCreator = favoriteRepositoryActionCreator
        self.favoriteRepositoryStore = favoriteRepositoryStore
    }
}
