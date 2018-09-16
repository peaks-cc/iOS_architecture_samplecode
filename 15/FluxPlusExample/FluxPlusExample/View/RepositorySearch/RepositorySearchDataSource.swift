//
//  RepositorySearchDataSource.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class RepositorySearchDataSource: NSObject {

    private let viewModel: RepositorySearchViewModel

    init(viewModel: RepositorySearchViewModel) {
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

extension RepositorySearchDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHubRepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHubRepositoryCell {
            let repository = viewModel.repositories.value[indexPath.row]
            repositoryCell.configure(with: repository)
        }

        return cell
    }
}

extension RepositorySearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.selectedIndexPath(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y {
            viewModel.reachBottom()
        }
    }
}
