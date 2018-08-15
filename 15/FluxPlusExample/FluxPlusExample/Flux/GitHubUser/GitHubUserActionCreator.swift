//
//  GitHubUserActionCreator.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class GitHubUserActionCreator {
    static let shared = GitHubUserActionCreator()

    private let dispatcher: GitHubUserDispatcher

    private let _fetchRepositories = PublishRelay<(String, Int)>()
    private let disposeBag = DisposeBag()

    init(dispatcher: GitHubUserDispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared) {
        self.dispatcher = dispatcher

        let usersAndPagination = _fetchRepositories
            .flatMap { query, page -> Observable<GitHub.Result<([GitHub.User], GitHub.Pagination)>> in
                apiSession.searchUsers(query: query, page: page)
                    .asObservable()
                    .map { .success($0) }
                    .catchError { .just(.failure($0)) }
            }
            .share()

        Observable.merge(usersAndPagination.map { _ in false },
                         _fetchRepositories.map { _ in true })
            .bind(to: dispatcher.isFetching)
            .disposed(by: disposeBag)

        usersAndPagination
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: dispatcher.error)
            .disposed(by: disposeBag)

        let element = usersAndPagination
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .share()

        element
            .map { $0.0 }
            .bind(to: dispatcher.addUsers)
            .disposed(by: disposeBag)

        element
            .map { $0.1 }
            .bind(to: dispatcher.pagination)
            .disposed(by: disposeBag)

        _fetchRepositories
            .map { $0.0 }
            .bind(to: dispatcher.searchQuery)
            .disposed(by: disposeBag)
    }

    func searchUsers(query: String, page: Int = 1) {
        _fetchRepositories.accept((query, page))
    }

    func setSelectedUser(_ user: GitHub.User?) {
        dispatcher.selectedUser.accept(user)
    }

    func setIsSearchUsersFieldEditing(_ isEditing: Bool) {
        dispatcher.isFieldEditing.accept(isEditing)
    }

    func clearUsers() {
        dispatcher.clearUsers.accept(())
    }
}
