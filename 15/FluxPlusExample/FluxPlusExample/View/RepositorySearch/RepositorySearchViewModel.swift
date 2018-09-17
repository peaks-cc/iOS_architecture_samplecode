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

    let reloadData: Observable<Void>
    let editingLayout: Observable<Void>
    let nonEditingLayout: Observable<Void>
    let showRepositoryDetail: Observable<Void>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let _reachBottom = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(viewDidAppear: Observable<Void>,
         viewDidDisappear: Observable<Void>,
         searchText: Observable<String?>,
         cancelButtonClicked: Observable<Void>,
         textDidBeginEditing: Observable<Void>,
         searchButtonClicked: Observable<Void>,
         flux: Flux) {
        let searchStore = flux.searchRepositoryStore
        let searchActionCreator = flux.searchRepositoryActionCreator
        let selectedStore = flux.selectedRepositoryStore
        let selectedActionCreator = flux.selectedRepositoryActionCreator

        self.repositories = searchStore.repositories

        self.reloadData = repositories.asObservable()
            .map { _ in }

        self.editingLayout = searchStore.isSearchFieldEditing.asObservable()
            .flatMap { $0 ? Observable.just(()) : .empty() }

        self.nonEditingLayout = searchStore.isSearchFieldEditing.asObservable()
            .flatMap { $0 ? .empty() : Observable.just(()) }

        self.showRepositoryDetail = Observable.merge(viewDidAppear.map { _ in true },
                                                     viewDidDisappear.map { _ in false })
            .flatMapLatest { canSubscribe -> Observable<GitHub.Repository?> in
                if canSubscribe {
                    return selectedStore.repository.changed
                } else {
                    return .empty()
                }
            }
            .flatMap { favorite -> Observable<Void> in
                favorite == nil ? .empty() : .just(())
            }

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

        let text = searchText
            .flatMap { $0.map(Observable.just) ?? .empty() }

        searchButtonClicked
            .withLatestFrom(text)
            .filter { !$0.isEmpty }
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
