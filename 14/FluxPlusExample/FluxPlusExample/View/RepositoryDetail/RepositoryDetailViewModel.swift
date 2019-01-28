//
//  RepositoryDetailViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class RepositoryDetailViewModel {

    let estimatedProgress: Observable<Double>
    let favoriteButtonTitile: Observable<String>
    let repository: Observable<GitHub.Repository>

    private let selectedActionCreator: SelectedRepositoryActionCreator

    private let disposeBag = DisposeBag()

    deinit {
        selectedActionCreator.setSelectedRepository(nil)
    }

    init(estimatedProgress: Observable<Double?>,
         favoriteButtonTap: Observable<Void>,
         flux: Flux) {
        let selectedStore = flux.selectedRepositoryStore
        let selectedActionCreator = flux.selectedRepositoryActionCreator
        let favoriteStore = flux.favoriteRepositoryStore
        let favoriteActionCreator = flux.favoriteRepositoryActionCreator

        self.selectedActionCreator = selectedActionCreator

        self.estimatedProgress = estimatedProgress
            .flatMap { estimatedProgress -> Observable<Double> in
                estimatedProgress.map(Observable.just) ?? .empty()
            }

        let repository = selectedStore.repository.asObservable()
            .flatMap { repository -> Observable<GitHub.Repository> in
                repository.map(Observable.just) ?? .empty()
            }
            .share(replay: 1, scope: .whileConnected)

        self.repository = repository

        let isFavorite = favoriteStore.repositories.asObservable()
            .withLatestFrom(repository) { ($0, $1) }
            .map { respositories, repository -> Bool in
                respositories.contains { $0.id == repository.id }
            }
            .share(replay: 1, scope: .whileConnected)

        self.favoriteButtonTitile = isFavorite
            .map { $0 ? "🌟 Unstar" : "⭐️ Star" }
            .share(replay: 1, scope: .whileConnected)

        favoriteButtonTap
            .withLatestFrom(isFavorite)
            .withLatestFrom(repository) { ($0, $1) }
            .subscribe(onNext: { isFavorite, repository in
                if isFavorite {
                    favoriteActionCreator.removeFavoriteRepository(repository)
                } else {
                    favoriteActionCreator.addFavoriteRepository(repository)
                }
            })
            .disposed(by: disposeBag)
    }
}
