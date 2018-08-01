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
    private let actionCreator: ActionCreator

    private let cellIdentifier = "Cell"

    init(repositoryStore: GitHubRepositoryStore,
         actionCreator: ActionCreator) {
        self.repositoryStore = repositoryStore
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
}
