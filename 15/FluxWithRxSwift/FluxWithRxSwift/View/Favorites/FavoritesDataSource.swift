//
//  FavoritesDataSource.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import GitHub

final class FavoritesDataSource: NSObject {

    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator

    init(actionCreator: ActionCreator = .init(),
         favoriteRepositoryStore: FavoriteRepositoryStore = .shared) {
        self.favoriteStore = favoriteRepositoryStore
        self.actionCreator = actionCreator
        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(GitHub.RepositoryCell.nib,
                           forCellReuseIdentifier: GitHub.RepositoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FavoritesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStore.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = favoriteStore.repositories[indexPath.row]
            repositoryCell.configure(with: repository)
        }
        return cell
    }
}

extension FavoritesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let repository = favoriteStore.repositories[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }
}
