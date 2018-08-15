//
//  SearchUsersViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/14.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SearchUsersViewModel {
    let users: Property<[GitHub.User]>
    let pagination: Property<GitHub.Pagination?>
    let isFetching: Property<Bool>
    let query: Property<String?>

    let reloadData: Observable<Void>
    let isFieldEditing: Observable<Bool>
    let showUserRepositories: Observable<Void>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let _reachBottom = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(searchText: Observable<String?>,
         cancelButtonClicked: Observable<Void>,
         textDidBeginEditing: Observable<Void>,
         searchButtonClicked: Observable<Void>,
         flux: Flux) {
        let store = flux.userStore
        let actionCreator = flux.userActionCreator

        self.users = store.users
        self.pagination = store.pagination
        self.isFetching = store.isFetching
        self.query = store.query

        self.reloadData = store.users.asObservable()
            .map { _ in }

        self.isFieldEditing = store.isFieldEditing.asObservable()

        self.showUserRepositories = store.selectedUser.asObservable()
            .flatMap { user -> Observable<Void> in
                user == nil ? .empty() : .just(())
            }

        cancelButtonClicked
            .subscribe(onNext: {
                actionCreator.setIsSearchUsersFieldEditing(false)
            })
            .disposed(by: disposeBag)

        textDidBeginEditing
            .subscribe(onNext: {
                actionCreator.setIsSearchUsersFieldEditing(true)
            })
            .disposed(by: disposeBag)

        let text = searchText
            .flatMap { $0.map(Observable.just) ?? .empty() }

        searchButtonClicked
            .withLatestFrom(text)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { text in
                actionCreator.clearUsers()
                actionCreator.searchUsers(query: text)
                actionCreator.setIsSearchUsersFieldEditing(false)
            })
            .disposed(by: disposeBag)

        _selectedIndexPath
            .withLatestFrom(users.asObservable()) { $1[$0.row] }
            .subscribe(onNext: {
                actionCreator.setSelectedUser($0)
            })
            .disposed(by: disposeBag)

        _reachBottom
            .withLatestFrom(query.asObservable())
            .withLatestFrom(pagination.asObservable()) { ($0, $1) }
            .withLatestFrom(isFetching.asObservable()) { ($0.0, $0.1, $1) }
            .flatMap { query, pagination, isFetching -> Observable<(String, Int)> in
                if let query = query, let next = pagination?.next,
                    pagination?.last != nil && !isFetching {
                    return .just((query, next))
                } else {
                    return .empty()
                }
            }
            .subscribe(onNext: { query, page in
                actionCreator.searchUsers(query: query, page: page)
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
