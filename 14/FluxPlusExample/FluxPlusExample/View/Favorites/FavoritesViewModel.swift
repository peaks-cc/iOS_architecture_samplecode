//
//  FavoritesViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class FavoritesViewModel {
    
    let favorites: Property<[GitHub.Repository]>

    let reloadFavorites: Observable<Void>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()

    init(flux: Flux) {
        let selectedActionCreator = flux.selectedRepositoryActionCreator
        let favoriteStore = flux.favoriteRepositoryStore

        self.favorites = favoriteStore.repositories

        self.reloadFavorites = favorites.changed
            .map { _ in }

        _selectedIndexPath
            .withLatestFrom(favorites.asObservable()) { $1[$0.row] }
            .subscribe(onNext: { repository in
                selectedActionCreator.setSelectedRepository(repository)
            })
            .disposed(by: disposeBag)
    }

    func selectedIndexPath(_ indexPath: IndexPath) {
        _selectedIndexPath.accept(indexPath)
    }
}

