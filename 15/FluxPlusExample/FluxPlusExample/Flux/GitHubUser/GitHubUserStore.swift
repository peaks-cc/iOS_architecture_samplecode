//
//  GitHubUserStore.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class GitHubUserStore {
    static let shared = GitHubUserStore()

    private let disposeBag = DisposeBag()

    let users: Property<[GitHub.User]>
    private let _users = BehaviorRelay<[GitHub.User]>(value: [])

    let selectedUser: Property<GitHub.User?>
    private let _selectedUser = BehaviorRelay<GitHub.User?>(value: nil)

    let pagination: Property<GitHub.Pagination?>
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)

    let isFieldEditing: Property<Bool>
    private let _isFieldEditing = BehaviorRelay<Bool>(value: false)

    let isFetching: Property<Bool>
    private let _isFetching = BehaviorRelay<Bool>(value: false)

    let query: Property<String?>
    private let _query = BehaviorRelay<String?>(value: nil)

    let error: Observable<Error>

    init(dispatcher: GitHubUserDispatcher = .shared) {
        self.users = Property(_users)
        self.selectedUser = Property(_selectedUser)
        self.pagination = Property(_pagination)
        self.isFieldEditing = Property(_isFieldEditing)
        self.isFetching = Property(_isFetching)
        self.query = Property(_query)

        dispatcher.addUsers
            .withLatestFrom(_users) { $1 + $0 }
            .bind(to: _users)
            .disposed(by: disposeBag)

        dispatcher.clearUsers
            .map { [] }
            .bind(to: _users)
            .disposed(by: disposeBag)

        dispatcher.selectedUser
            .bind(to: _selectedUser)
            .disposed(by: disposeBag)

        dispatcher.pagination
            .bind(to: _pagination)
            .disposed(by: disposeBag)

        dispatcher.isFieldEditing
            .bind(to: _isFieldEditing)
            .disposed(by: disposeBag)

        dispatcher.isFetching
            .bind(to: _isFetching)
            .disposed(by: disposeBag)

        dispatcher.searchQuery
            .bind(to: _query)
            .disposed(by: disposeBag)

        self.error = dispatcher.error.asObservable()
    }
}
