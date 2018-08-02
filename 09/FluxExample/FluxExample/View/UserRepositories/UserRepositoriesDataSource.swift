//
//  UserRepositoriesDataSource.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class UserRepositoriesDataSource: NSObject {

    private let repositoryStore: GitHubRepositoryStore
    private let userStore: GitHubUserStore
    private let actionCreator: ActionCreator

    private let cellIdentifier = "Cell"

    init(repositoryStore: GitHubRepositoryStore,
         userStore: GitHubUserStore,
         actionCreator: ActionCreator) {
        self.repositoryStore = repositoryStore
        self.userStore = userStore
        self.actionCreator = actionCreator
    }

    func configure(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension UserRepositoriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryStore.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let repository = repositoryStore.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
}

extension UserRepositoriesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositoryStore.repositories[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let username = userStore.selectedUser?.login, let next = repositoryStore.pagination?.next,
            repositoryStore.pagination?.last != nil &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y &&
            !repositoryStore.isFetching {
            actionCreator.fetchRepositories(username: username, page: next)
        }
    }
}
