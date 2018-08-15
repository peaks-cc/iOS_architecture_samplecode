//
//  UserRepositoriesViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class UserRepositoriesViewModel {

    let repositories: Property<[GitHub.Repository]>

    let reloadData: Observable<Void>
    let showRepositoryDetail: Observable<Void>
    let title: Observable<String>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let _reachBottom = PublishRelay<Void>()

    private let userActionCreator: GitHubUserActionCreator
    private let repositoryActionCreator: GitHubRepositoryActionCreator
    private let disposeBag = DisposeBag()

    deinit {
        userActionCreator.setSelectedUser(nil)
        repositoryActionCreator.clearRepositories()
    }

    init(flux: Flux) {

        let store = flux.repositoryStore
        self.userActionCreator = flux.userActionCreator
        self.repositoryActionCreator = flux.repositoryActionCreator

        self.repositories = store.repositories

        self.reloadData = store.repositories.asObservable()
            .map { _ in }

        self.showRepositoryDetail = store.selectedRepository.asObservable()
            .flatMap { repository -> Observable<Void> in
                repository == nil ? .empty() : .just(())
            }

        let username: Observable<String> = flux.userStore.selectedUser.asObservable()
            .flatMap { $0.map { Observable.just($0.login) } ?? .empty() }
            .share(replay: 1, scope: .whileConnected)

        self.title = username

        let actionCreator = flux.repositoryActionCreator

        _selectedIndexPath
            .withLatestFrom(repositories.asObservable()) { $1[$0.row] }
            .subscribe(onNext: {
                actionCreator.setSelectedRepository($0)
            })
            .disposed(by: disposeBag)

        _reachBottom
            .withLatestFrom(username)
            .withLatestFrom(store.pagination.asObservable()) { ($0, $1) }
            .withLatestFrom(store.isFetching.asObservable()) { ($0.0, $0.1, $1) }
            .subscribe(onNext: { username, pagination, isFetching in
                if let next = pagination?.next, pagination?.last != nil && !isFetching {
                    actionCreator.fetchRepositories(username: username, page: next)
                }
            })
            .disposed(by: disposeBag)

        username
            .subscribe(onNext: {
                actionCreator.fetchRepositories(username: $0)
            })
            .disposed(by: disposeBag)
    }

    func selectedIndexPath(_ indexPath: IndexPath) {
        _selectedIndexPath.accept(indexPath)
    }

    func reachBottom() {
        _reachBottom.accept(())
    }
}
