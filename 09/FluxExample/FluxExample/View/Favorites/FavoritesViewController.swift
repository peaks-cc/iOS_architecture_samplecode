//
//  FavoritesViewController.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let selectedStore: SelectedRepositoryStore
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator
    private let dataSource: FavoritesDataSource

    private var showRepositorySubscription: Subscription?
    private lazy var reloadSubscription: Subscription = {
        return favoriteStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0) , with: .fade)
            }
        }
    }()

    init(selectedStore: SelectedRepositoryStore = .shared,
         favoriteStore: FavoriteRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.selectedStore = selectedStore
        self.favoriteStore = favoriteStore
        self.actionCreator = actionCreator
        self.dataSource = FavoritesDataSource(favoriteStore: favoriteStore,
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
        _ = reloadSubscription
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        subscribeStore()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        unsubscribeStore()
    }

    private func unsubscribeStore() {
        if let subscription = showRepositorySubscription {
            selectedStore.removeListener(subscription)
            showRepositorySubscription = nil
        }
    }

    private func subscribeStore() {
        guard showRepositorySubscription == nil else {
            return
        }

        showRepositorySubscription = selectedStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.showRepositoryDetail()
            }
        }
    }

    private func showRepositoryDetail() {
        if selectedStore.repository == nil {
            return
        }
        unsubscribeStore()
        
        let vc = RepositoryDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
