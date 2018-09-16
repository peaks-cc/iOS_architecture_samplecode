//
//  FavoritesDataSource.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class FavoritesDataSource: NSObject {

    private let favoriteStore: FavoriteRepositoryStore
    private let selectedActionCreator: SelectedRepositoryActionCreator

    private let cellIdentifier = "Cell"

    init(flux: Flux) {
        self.favoriteStore = flux.favoriteRepositoryStore
        self.selectedActionCreator = flux.selectedRepositoryActionCreator
        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(GitHubRepositoryCell.nib,
                           forCellReuseIdentifier: GitHubRepositoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FavoritesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStore.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHubRepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHubRepositoryCell {
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
        selectedActionCreator.setSelectedRepository(repository)
    }
}
