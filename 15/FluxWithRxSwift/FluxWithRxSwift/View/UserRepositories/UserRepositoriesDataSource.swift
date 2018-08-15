//
//  UserRepositoriesDataSource.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class UserRepositoriesDataSource: NSObject {

    private let flux: Flux

    private let cellIdentifier = "Cell"

    init(flux: Flux) {
        self.flux = flux
    }

    func configure(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension UserRepositoriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flux.repositoryStore.repositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let repository = flux.repositoryStore.repositories.value[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
}

extension UserRepositoriesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = flux.repositoryStore.repositories.value[indexPath.row]
        flux.repositoryActionCreator.setSelectedRepository(repository)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let username = flux.userStore.selectedUser?.login, let next = flux.repositoryStore.pagination.value?.next,
            flux.repositoryStore.pagination.value?.last != nil &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y &&
            !flux.repositoryStore.isFetching.value {
            flux.repositoryActionCreator.fetchRepositories(username: username, page: next)
        }
    }
}

