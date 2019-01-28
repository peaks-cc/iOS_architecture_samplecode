//
//  RepositorySearchViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class RepositorySearchViewModel {
    let repositories: Property<[GitHub.Repository]>

    let reloadRepositories: Observable<Void>
    let editingLayout: Observable<Void>
    let nonEditingLayout: Observable<Void>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let _reachBottom = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(searchText: Observable<String?>,
         cancelButtonClicked: Observable<Void>,
         textDidBeginEditing: Observable<Void>,
         searchButtonClicked: Observable<Void>,
         flux: Flux) {
        let searchStore = flux.searchRepositoryStore
        let searchActionCreator = flux.searchRepositoryActionCreator
        let selectedActionCreator = flux.selectedRepositoryActionCreator

        self.repositories = searchStore.repositories

        self.reloadRepositories = repositories.changed
            .map { _ in }

        self.editingLayout = searchStore.isSearchFieldEditing.asObservable()
            .flatMap { $0 ? Observable.just(()) : .empty() }

        self.nonEditingLayout = searchStore.isSearchFieldEditing.asObservable()
            .flatMap { $0 ? .empty() : Observable.just(()) }

        cancelButtonClicked
            .subscribe(onNext: {
                searchActionCreator.setIsSearchFieldEditing(false)
            })
            .disposed(by: disposeBag)

        textDidBeginEditing
            .subscribe(onNext: {
                searchActionCreator.setIsSearchFieldEditing(true)
            })
            .disposed(by: disposeBag)

        searchButtonClicked
            .withLatestFrom(searchText)
            .flatMap { text -> Observable<String> in
                guard let text = text, !text.isEmpty else {
                    return .empty()
                }
                return .just(text)
            }
            .subscribe(onNext: { text in
                searchActionCreator.clearRepositories()
                searchActionCreator.searchRepositories(query: text)
                searchActionCreator.setIsSearchFieldEditing(false)
            })
            .disposed(by: disposeBag)

        _selectedIndexPath
            .withLatestFrom(repositories.asObservable()) { $1[$0.row] }
            .subscribe(onNext: {
                selectedActionCreator.setSelectedRepository($0)
            })
            .disposed(by: disposeBag)

        _reachBottom
            .withLatestFrom(searchStore.query.asObservable())
            .withLatestFrom(searchStore.pagination.asObservable()) { ($0, $1) }
            .withLatestFrom(searchStore.isFetching.asObservable()) { ($0.0, $0.1, $1) }
            .flatMap { query, pagination, isFetching -> Observable<(String, Int)> in
                if let query = query, let next = pagination?.next,
                    pagination?.last != nil && !isFetching {
                    return .just((query, next))
                } else {
                    return .empty()
                }
            }
            .subscribe(onNext: { query, page in
                searchActionCreator.searchRepositories(query: query, page: page)
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
