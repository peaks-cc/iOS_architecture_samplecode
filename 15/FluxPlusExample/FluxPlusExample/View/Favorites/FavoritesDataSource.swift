//
//  FavoritesDataSource.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import GitHub

final class FavoritesDataSource: NSObject {

    private let favorites: Property<[GitHub.Repository]>
    private let selectedIndexPath: (IndexPath) -> ()

    init(favorites: Property<[GitHub.Repository]>,
         selectedIndexPath: @escaping (IndexPath) -> ()) {
        self.favorites = favorites
        self.selectedIndexPath = selectedIndexPath

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
        return favorites.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = favorites.value[indexPath.row]
            repositoryCell.configure(with: repository)
        }

        return cell
    }
}

extension FavoritesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndexPath(indexPath)
    }
}
