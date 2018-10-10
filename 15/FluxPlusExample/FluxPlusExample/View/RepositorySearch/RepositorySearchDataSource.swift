//
//  RepositorySearchDataSource.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import GitHub

final class RepositorySearchDataSource: NSObject {

    private let repositories: Property<[GitHub.Repository]>
    private let selectedIndexPath: (IndexPath) -> ()
    private let reachBottom: () -> ()

    init(repositories: Property<[GitHub.Repository]>,
         selectedIndexPath: @escaping (IndexPath) -> (),
         reachBottom: @escaping () -> ()) {
        self.repositories = repositories
        self.selectedIndexPath = selectedIndexPath
        self.reachBottom = reachBottom

        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(GitHub.RepositoryCell.nib,
                           forCellReuseIdentifier: GitHub.RepositoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension RepositorySearchDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = repositories.value[indexPath.row]
            repositoryCell.configure(with: repository)
        }

        return cell
    }
}

extension RepositorySearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndexPath(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y {
            reachBottom()
        }
    }
}
