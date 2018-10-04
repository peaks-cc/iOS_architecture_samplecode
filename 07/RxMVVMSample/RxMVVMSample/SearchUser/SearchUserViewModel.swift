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

class SearchUserViewModel {
    // TODO: be injectable
    private let searchUserModel = SearchUserModel()
    private let disposeBag = DisposeBag()

    // values
    private(set) var users = BehaviorRelay<[User]>(value: [])
    var searchBarText = BehaviorRelay<String?>(value: nil)

    // events
    var didTapSearchButton = PublishSubject<Void>()

    init(searchBarTextObs: Observable<String?>, searchButtonClicked: Observable<Void>, itemSelected: Observable<IndexPath>, reloadData: AnyObserver<Void>, transitionToUserDetail: AnyObserver<String>) {
        searchBarTextObs
            .bind(to: searchBarText)
            .disposed(by: disposeBag)

        searchButtonClicked
            .bind(to: didTapSearchButton)
            .disposed(by: disposeBag)

        itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let userName = self?.users.value[indexPath.row].login else { return }
            transitionToUserDetail.onNext(userName)
        }).disposed(by: disposeBag)

        users
            .map{ _ in}
            .subscribe { _ in
                reloadData.onNext(())
            }.disposed(by: disposeBag)

        didTapSearchButton.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }

            // TODO: call api
            guard let query = strongSelf.searchBarText.value else { return }
            strongSelf.searchUserModel.fetchUser(query: query, completion: { result in
                switch result {
                case .success(let users):
                    strongSelf.users.accept(users)
                case .failure(let error):
                    // TODO: Error Handling
                    ()
                }
            })
        }).disposed(by: disposeBag)
    }
}
