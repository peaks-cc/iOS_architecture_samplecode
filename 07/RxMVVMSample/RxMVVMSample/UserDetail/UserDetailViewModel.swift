//
//  UserDetailViewModel.swift
//  RxMVVMSample
//
//  Created by Kenji Tanaka on 2018/10/06.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

class UserDetailViewModel {
    let userName: String
    var repositories: [Repository] { return _repositories.value }

    private let _repositories = BehaviorRelay<[Repository]>(value: [])

    private let model: UserDetailModelProtocol

    private let disposeBag = DisposeBag()

    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToRepositoryDetail: Observable<(String, String)>

    init(userName: String, itemSelected: Observable<IndexPath>, model: UserDetailModelProtocol?) {
        self.userName = userName

        self.model = model ?? UserDetailModel(userName: userName)

        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _repositories.map { _ in }
        self.transitionToRepositoryDetail = itemSelected
            .withLatestFrom(_repositories) { ($0, $1) }
            .flatMap { indexPath, repositories -> Observable<(String, String)> in
                guard indexPath.row < repositories.count else {
                    return .empty()
                }

                return .just((userName, repositories[indexPath.row].name))
        }

        let fetchRepositoriesResponse = self.model
            .fetchRepositories()
            .materialize()

        fetchRepositoriesResponse
            .flatMap { event -> Observable<[Repository]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        fetchRepositoriesResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
            }.subscribe { error in
                // TODO: Error Handling
            }.disposed(by: disposeBag)
    }
}
