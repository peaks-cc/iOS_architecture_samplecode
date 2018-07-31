//
//  UserRepositoriesViewController.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class UserRepositoriesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let userStore: GithubUserStore
    private let repositoryStore: GithubRepositoryStore
    private let actionCreator: ActionCreator
    private let dataSource: UserRepositoriesDataSource

    private var showRepositorySubscription: Subscription?
    private lazy var reloadSubscription: Subscription = {
        return repositoryStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0) , with: .fade)
            }
        }
    }()

    deinit {
        actionCreator.setSelectedUser(nil)
        actionCreator.clearRepositories()
    }

    init(userStore: GithubUserStore = .shared,
         repositoryStore: GithubRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.userStore = userStore
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator
        self.dataSource = UserRepositoriesDataSource(repositoryStore: repositoryStore,
                                                     actionCreator: actionCreator)

        super.init(nibName: "UserRepositoriesViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = userStore.selectedUser else {
            return
        }

        title = user.login

        dataSource.configure(tableView)
        _ = reloadSubscription

        actionCreator.fetchRepositories(username: user.login)
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
        let vc = RepositoryDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
