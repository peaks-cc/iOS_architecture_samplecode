//
//  SearchRepositoryStore.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SearchRepositoryStore {
    static let shared = SearchRepositoryStore()

    let query: Property<String?>
    private let _query = BehaviorRelay<String?>(value: nil)

    let pagination: Property<GitHub.Pagination?>
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)

    let isSearchFieldEditing: Property<Bool>
    private let _isSearchFieldEditing = BehaviorRelay<Bool>(value: false)

    let isFetching: Property<Bool>
    private let _isFetching = BehaviorRelay<Bool>(value: false)

    let repositories: Property<[GitHub.Repository]>
    private let _repositories = BehaviorRelay<[GitHub.Repository]>(value: [])

    let error: Observable<Error>

    private let disposeBag = DisposeBag()

    init(dispatcher: SearchRepositoryDispatcher = .shared) {
        self.query = Property(_query)
        self.pagination = Property(_pagination)
        self.isSearchFieldEditing = Property(_isSearchFieldEditing)
        self.isFetching = Property(_isFetching)
        self.repositories = Property(_repositories)
        self.error = dispatcher.error.asObservable()

        dispatcher.query
            .bind(to: _query)
            .disposed(by: disposeBag)

        dispatcher.pagination
            .bind(to: _pagination)
            .disposed(by: disposeBag)

        dispatcher.addRepositories
            .withLatestFrom(_repositories) { $1 + $0 }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.clearRepositories
            .map { [] }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.isSearchFieldEditing
            .bind(to: _isSearchFieldEditing)
            .disposed(by: disposeBag)

        dispatcher.isFetching
            .bind(to: _isFetching)
            .disposed(by: disposeBag)
    }
}
