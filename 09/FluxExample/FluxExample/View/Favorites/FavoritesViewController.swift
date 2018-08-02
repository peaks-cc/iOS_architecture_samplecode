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

    private let repositoryStore: GitHubRepositoryStore
    private let actionCreator: ActionCreator
    private let dataSource: FavoritesDataSource

    private var showRepositorySubscription: Subscription?
    private lazy var reloadSubscription: Subscription = {
        return repositoryStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0) , with: .fade)
            }
        }
    }()

    init(repositoryStore: GitHubRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
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
            repositoryStore.removeListener(subscription)
            showRepositorySubscription = nil
        }
    }

    private func subscribeStore() {
        guard showRepositorySubscription == nil else {
            return
        }

        showRepositorySubscription = repositoryStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.showRepositoryDetail()
            }
        }
    }

    private func showRepositoryDetail() {
        if repositoryStore.selectedRepository == nil {
            return
        }
        unsubscribeStore()
        
        let vc = RepositoryDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
