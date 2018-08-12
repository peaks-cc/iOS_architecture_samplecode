//
//  FavoritesViewController.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let repositoryStore: GitHubRepositoryStore
    private let actionCreator: GitHubRepositoryActionCreator

    private let dataSource: FavoritesDataSource
    private let disposeBag = DisposeBag()

    init(repositoryStore: GitHubRepositoryStore = .shared,
         actionCreator: GitHubRepositoryActionCreator = .shared) {
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator
        self.dataSource = FavoritesDataSource(repositoryStore: repositoryStore,
                                              actionCreator: actionCreator)

        super.init(nibName: "FavoritesViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        dataSource.configure(tableView)

        repositoryStore.favoritesObservable
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        repositoryStore.selectedRepositoryObservable
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

