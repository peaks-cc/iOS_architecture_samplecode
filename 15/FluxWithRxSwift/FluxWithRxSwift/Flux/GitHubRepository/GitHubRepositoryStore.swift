//
//  GitHubRepositoryStore.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/12.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class GitHubRepositoryStore {
    static let shared = GitHubRepositoryStore()

    private let _repositories = BehaviorRelay<[GitHub.Repository]>(value: [])
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)
    private let _selectedRepository = BehaviorRelay<GitHub.Repository?>(value: nil)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _favorites = BehaviorRelay<[GitHub.Repository]>(value: [])

    let error: Observable<Error>

    private let disposeBag = DisposeBag()

    init(dispatcher: GitHubRepositoryDispatcher = .shared) {
        self.error = dispatcher.error.asObservable()

        dispatcher.addRepositories
            .withLatestFrom(_repositories) { $1 + $0 }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.clearRepositories
            .map { [] }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.pagination
            .bind(to: _pagination)
            .disposed(by: disposeBag)

        dispatcher.selectedRepository
            .bind(to: _selectedRepository)
            .disposed(by: disposeBag)

        dispatcher.isFetching
            .bind(to: _isFetching)
            .disposed(by: disposeBag)

        dispatcher.favorites
            .bind(to: _favorites)
            .disposed(by: disposeBag)
    }
}

// MARK: - Values
extension GitHubRepositoryStore {
    var repositories: [GitHub.Repository] {
        return _repositories.value
    }
    var pagination: GitHub.Pagination? {
        return _pagination.value
    }
    var selectedRepository: GitHub.Repository? {
        return _selectedRepository.value
    }
    var isFetching: Bool {
        return _isFetching.value
    }
    var favorites: [GitHub.Repository] {
        return _favorites.value
    }
}

// MARK: - Observables
extension GitHubRepositoryStore {
    var repositoriesObservable: Observable<[GitHub.Repository]> {
        return _repositories.asObservable()
    }
    var paginationObservable: Observable<GitHub.Pagination?> {
        return _pagination.asObservable()
    }
    var selectedRepositoryObservable: Observable<GitHub.Repository?> {
        return _selectedRepository.asObservable()
    }
    var isFetchingObservable: Observable<Bool> {
        return _isFetching.asObservable()
    }
    var favoritesObservable: Observable<[GitHub.Repository]> {
        return _favorites.asObservable()
    }
}
