//
//  GitHubRepositoryStore.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/12.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class GitHubRepositoryStore {
    static let shared = GitHubRepositoryStore()

    let repositories: Property<[GitHub.Repository]>
    private let _repositories = BehaviorRelay<[GitHub.Repository]>(value: [])

    let pagination: Property<GitHub.Pagination?>
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)

    let selectedRepository: Property<GitHub.Repository?>
    private let _selectedRepository = BehaviorRelay<GitHub.Repository?>(value: nil)

    let isFetching: Property<Bool>
    private let _isFetching = BehaviorRelay<Bool>(value: false)

    let favorites: Property<[GitHub.Repository]>
    private let _favorites = BehaviorRelay<[GitHub.Repository]>(value: [])

    let error: Observable<Error>

    private let disposeBag = DisposeBag()

    init(dispatcher: GitHubRepositoryDispatcher = .shared) {
        self.repositories = Property(_repositories)
        self.pagination = Property(_pagination)
        self.selectedRepository = Property(_selectedRepository)
        self.isFetching = Property(_isFetching)
        self.favorites = Property(_favorites)

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
