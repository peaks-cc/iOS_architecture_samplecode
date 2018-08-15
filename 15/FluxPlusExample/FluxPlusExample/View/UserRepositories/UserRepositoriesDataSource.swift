//
//  UserRepositoriesDataSource.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class UserRepositoriesDataSource: NSObject {

    private let viewModel: UserRepositoriesViewModel

    private let cellIdentifier = "Cell"

    init(viewModel: UserRepositoriesViewModel) {
        self.viewModel = viewModel
    }

    func configure(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension UserRepositoriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let repository = viewModel.repositories.value[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
}

extension UserRepositoriesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.reachBottom()
    }
}

