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

final class UserDetailViewModel {
    let userName: GitHub.User.Name
    var repositories: [Repository] { return _repositories.value }

    private let _repositories = BehaviorRelay<[Repository]>(value: [])

    private let model: UserDetailModelInput

    private let disposeBag = DisposeBag()

    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>

    init(userName: GitHub.User.Name, itemSelected: Observable<IndexPath>, model: UserDetailModelInput? = nil) {
        self.userName = userName

        self.model = model ?? UserDetailModel(userName: userName)

        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _repositories.map { _ in }

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
