//
//  FavoritesViewController.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import UIKit
import RxCocoa
import RxSwift

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let favoriteStore: FavoriteRepositoryStore
    private let selectedStore: SelectedRepositoryStore

    private let dataSource: FavoritesDataSource
    private let disposeBag = DisposeBag()

    init(actionCreator: ActionCreator = .init(),
         favoriteRepositoryStore: FavoriteRepositoryStore = .shared,
         selectedRepositoryStore: SelectedRepositoryStore = .shared) {
        self.favoriteStore = favoriteRepositoryStore
        self.selectedStore = selectedRepositoryStore
        self.dataSource = FavoritesDataSource(actionCreator: actionCreator,
                                              favoriteRepositoryStore: favoriteRepositoryStore)

        super.init(nibName: "FavoritesViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        dataSource.configure(tableView)

        favoriteStore.repositoriesObservable
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

