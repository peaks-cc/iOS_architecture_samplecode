//
//  GitHubRepositoryActionCreator.swift
//  FluxPlusExample
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
    private let localCache: LocalCacheable

    private let _fetchRepositories = PublishRelay<(String, Int)>()
    private let disposeBag = DisposeBag()

    init(dispatcher: GitHubRepositoryDispatcher = .shared,
         localCache: LocalCacheable = LocalCache.shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared) {
        self.dispatcher = dispatcher
        self.localCache = localCache

        let repositoriesAndPagination = _fetchRepositories
            .flatMap { username, page -> Observable<GitHub.Result<([GitHub.Repository], GitHub.Pagination)>> in
                apiSession.repositories(username: username, page: page)
                    .asObservable()
                    .map { .success($0) }
                    .catchError { .just(.failure($0)) }
            }
            .share()

        Observable.merge(repositoriesAndPagination.map { _ in false },
                         _fetchRepositories.map { _ in true })
            .bind(to: dispatcher.isFetching)
            .disposed(by: disposeBag)

        repositoriesAndPagination
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: dispatcher.error)
            .disposed(by: disposeBag)

        let element = repositoriesAndPagination
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .share()

        element
            .map { $0.0 }
            .bind(to: dispatcher.addRepositories)
            .disposed(by: disposeBag)

        element
            .map { $0.1 }
            .bind(to: dispatcher.pagination)
            .disposed(by: disposeBag)
    }

    func fetchRepositories(username: String,  page: Int = 1) {
        _fetchRepositories.accept((username, page))
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
