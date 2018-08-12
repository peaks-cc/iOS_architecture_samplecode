//
//  FavoritesDataSource.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class FavoritesDataSource: NSObject {

    private let repositoryStore: GitHubRepositoryStore
    private let actionCreator: GitHubRepositoryActionCreator

    private let cellIdentifier = "Cell"

    init(repositoryStore: GitHubRepositoryStore,
         actionCreator: GitHubRepositoryActionCreator) {
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator

        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FavoritesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryStore.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let repository = repositoryStore.favorites[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = "⭐️\(repository.stargazersCount) 🍴\(repository.forksCount)"

        return cell
    }
}

extension FavoritesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositoryStore.favorites[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }
}
