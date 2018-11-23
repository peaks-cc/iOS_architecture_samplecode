//
//  SearchUserViewModel.swift
//  RxMVVMSample
//
//  Created by Kenji Tanaka on 2018/10/04.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import RxSwift
import RxCocoa
import GitHub

final class SearchUserViewModel {
    private let searchUserModel: SearchUserModelProtocol
    private let disposeBag = DisposeBag()

    // computed values
    var users: [User] { return _users.value }

    // values
    private let _users = BehaviorRelay<[User]>(value: [])

    // observables
    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToUserDetail: Observable<GitHub.User.Name>

    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         searchUserModel: SearchUserModelProtocol = SearchUserModel()) {

        self.searchUserModel = searchUserModel

        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _users.map { _ in }
        self.transitionToUserDetail = itemSelected
            .withLatestFrom(_users) { ($0, $1) }
            .flatMap { indexPath, users -> Observable<GitHub.User.Name> in
                guard indexPath.row < users.count else {
                    return .empty()
                }
                return .just(users[indexPath.row].strictName)
            }

        let searchResponse = searchButtonClicked
            .withLatestFrom(searchBarText)
            .flatMapFirst { [weak self] text -> Observable<Event<[User]>> in
                guard let me = self, let query = text else {
                    return .empty()
                }
                return me.searchUserModel
                    .fetchUser(query: query)
                    .materialize()
            }
            .share()

        searchResponse
            .flatMap { event -> Observable<[User]> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _users)
            .disposed(by: disposeBag)

        searchResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
            }
            .subscribe(onNext: { error in
                // TODO: Error Handling
            })
            .disposed(by: disposeBag)
    }
}
