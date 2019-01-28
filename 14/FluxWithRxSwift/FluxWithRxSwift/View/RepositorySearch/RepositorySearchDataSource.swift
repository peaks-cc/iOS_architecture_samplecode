//
//  RepositorySearchDataSource.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import GitHub

final class RepositorySearchDataSource: NSObject {

    private let actionCreator: ActionCreator
    private let searchStore: SearchRepositoryStore

    init(actionCreator: ActionCreator,
         searchRepositoryStore: SearchRepositoryStore) {
        self.actionCreator = actionCreator
        self.searchStore = searchRepositoryStore

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
        return searchStore.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = searchStore.repositories[indexPath.row]
            repositoryCell.configure(with: repository)
        }
        return cell
    }
}

extension RepositorySearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let repository = searchStore.repositories[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let query = searchStore.query, let next = searchStore.pagination?.next,
            searchStore.pagination?.last != nil &&
            scrollView.contentSize.height > 0 &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y &&
            !searchStore.isFetching {
            actionCreator.searchRepositories(query: query, page: next)
        }
    }
}
