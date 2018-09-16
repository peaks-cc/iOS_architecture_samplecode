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

    init(flux: Flux = .shared) {
        self.favoriteStore = flux.favoriteRepositoryStore
        self.selectedStore = flux.selectedRepositoryStore
        self.dataSource = FavoritesDataSource(flux: flux)

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

        Observable.merge(self.extension.viewDidAppear.map { _ in true },
                         self.extension.viewDidDisappear.map { _ in false })
            .flatMapLatest { [selectedStore] canSubscribe -> Observable<GitHub.Repository?> in
                if canSubscribe {
                    return selectedStore.repositoryObservable.skip(1)
                } else {
                    return .empty()
                }
            }
            .flatMap { favorite -> Observable<Void> in
                favorite == nil ? .empty() : .just(())
            }
            .bind(to: Binder(self) { me, _ in
                let vc = RepositoryDetailViewController()
                 me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

