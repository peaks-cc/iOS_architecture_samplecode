//
//  GitHubRepositoryActionCreator.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class GitHubRepositoryActionCreator {
    static let shared = GitHubRepositoryActionCreator()

    private let dispatcher: GitHubRepositoryDispatcher
    private let apiSession: GitHubApiRequestable
    private let localCache: LocalCacheable

    init(dispatcher: GitHubRepositoryDispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared,
         localCache: LocalCacheable = LocalCache.shared) {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
        self.localCache = localCache
    }

    func fetchRepositories(username: String,  page: Int = 1) {
        dispatcher.isFetching.accept(true)
        _ = apiSession.repositories(username: username, page: page)
            .take(1)
            .subscribe(onNext: { [dispatcher] repositories, pagination in
                dispatcher.addRepositories.accept(repositories)
                dispatcher.pagination.accept(pagination)
                dispatcher.isFetching.accept(false)
            }, onError: { [dispatcher]  error in
                dispatcher.error.accept(error)
                dispatcher.isFetching.accept(false)
            })
    }

    func clearRepositories() {
        dispatcher.clearRepositories.accept(())
    }

    func setSelectedRepository(_ repository: GitHub.Repository?) {
        dispatcher.selectedRepository.accept(repository)
    }

    func addFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites] + [repository]
        localCache[.favorites] = repositories
        dispatcher.favorites.accept(repositories)
    }

    func removeFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites].filter { $0.id != repository.id }
        localCache[.favorites] = repositories
        dispatcher.favorites.accept(repositories)
    }

    func loadFavoriteRepositories() {
        dispatcher.favorites.accept(localCache[.favorites])
    }
}
