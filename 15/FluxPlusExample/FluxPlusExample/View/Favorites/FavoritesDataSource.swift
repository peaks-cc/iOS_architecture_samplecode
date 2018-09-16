//
//  FavoritesDataSource.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class FavoritesDataSource: NSObject {

    private let viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel

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
        return viewModel.favorites.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHubRepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHubRepositoryCell {
            let repository = viewModel.favorites.value[indexPath.row]
            repositoryCell.configure(with: repository)
        }

        return cell
    }
}

extension FavoritesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.selectedIndexPath(indexPath)
    }
}
