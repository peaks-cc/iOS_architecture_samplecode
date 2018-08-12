//
//  GitHubUserStore.swift
//  FluxWithRxSwift
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

    private let _users = BehaviorRelay<[GitHub.User]>(value: [])
    private let _selectedUser = BehaviorRelay<GitHub.User?>(value: nil)
    private let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)
    private let _isFieldEditing = BehaviorRelay<Bool>(value: false)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _query = BehaviorRelay<String?>(value: nil)

    let error: Observable<Error>

    init(dispatcher: GitHubUserDispatcher = .shared) {
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

// MARK: - Values
extension GitHubUserStore {
    var users: [GitHub.User] {
        return _users.value
    }
    var selectedUser: GitHub.User? {
        return _selectedUser.value
    }
    var pagination: GitHub.Pagination? {
        return _pagination.value
    }
    var isFieldEditing: Bool {
        return _isFieldEditing.value
    }
    var isFetching: Bool {
        return _isFetching.value
    }
    var query: String? {
        return _query.value
    }
}

// MARK: - Observables
extension GitHubUserStore {
    var usersObservable: Observable<[GitHub.User]> {
        return _users.asObservable()
    }
    var selectedUserObservable: Observable<GitHub.User?> {
        return _selectedUser.asObservable()
    }
    var paginationObservable: Observable<GitHub.Pagination?> {
        return _pagination.asObservable()
    }
    var isFieldEditingObservable: Observable<Bool> {
        return _isFieldEditing.asObservable()
    }
    var issFetchingObservable: Observable<Bool> {
        return _isFetching.asObservable()
    }
    var queryObservable: Observable<String?> {
        return _query.asObservable()
    }
}
