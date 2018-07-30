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

    private lazy var repositoryStoreSubscription: Subscription = {
        return repositoryStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0) , with: .fade)
                self?.showRepositoryDetail()
            }
        }
    }()

    deinit {
        actionCreator.setSelectedUser(nil)
        repositoryStore.removeListener(repositoryStoreSubscription)
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
        _ = repositoryStoreSubscription

        actionCreator.fetchRepositories(username: user.login)
    }

    private func showRepositoryDetail() {
        if repositoryStore.selectedRepository == nil {
            return
        }
        let vc = RepositoryDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
