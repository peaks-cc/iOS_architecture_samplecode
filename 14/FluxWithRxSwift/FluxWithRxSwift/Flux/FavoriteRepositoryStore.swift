//
//  FavoriteRepositoryStore.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class FavoriteRepositoryStore {
    static let shared = FavoriteRepositoryStore()

    private let _repositories = BehaviorRelay<[GitHub.Repository] >(value: [])

    private let disposeBag = DisposeBag()

    init(dispatcher: Dispatcher = .shared) {
        
        dispatcher.register(callback: { [weak self] action in
            guard let me = self else {
                return
            }

            switch action {
            case let .setFavoriteRepositories(repositories):
                me._repositories.accept(repositories)

            case .selectedRepository,
                 .searchRepositories,
                 .clearSearchRepositories,
                 .searchPagination,
                 .isRepositoriesFetching,
                 .isSearchFieldEditing,
                 .searchQuery,
                 .error:
                return

            }
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Values

extension FavoriteRepositoryStore {

    var repositories: [GitHub.Repository] {
        return _repositories.value
    }
}

// MARK: - Observables

extension FavoriteRepositoryStore {

    var repositoriesObservable: Observable<[GitHub.Repository]> {
        return _repositories.asObservable()
    }
}
