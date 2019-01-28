//
//  FavoriteRepositoryStore.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class FavoriteRepositoryStore {
    static let shared = FavoriteRepositoryStore()

    let repositories: Property<[GitHub.Repository] >
    private let _repositories = BehaviorRelay<[GitHub.Repository] >(value: [])

    private let disposeBag = DisposeBag()

    init(dispatcher: FavoriteRepositoryDispatcher = .shared) {
        self.repositories = Property(_repositories)

        dispatcher.repositories
            .bind(to: _repositories)
            .disposed(by: disposeBag)
    }
}

