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

    init(dispatcher: FavoriteRepositoryDispatcher = .shared) {
        dispatcher.repositories
            .bind(to: _repositories)
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
