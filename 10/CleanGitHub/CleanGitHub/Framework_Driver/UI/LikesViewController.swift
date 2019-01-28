//
//  LikesViewController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/17.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class LikesViewController: UITableViewController {

    private var viewDataArray = [GitHubRepoViewData]()
    private weak var presenter: ReposPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.collectLikedRepos()
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        let nib = RepositoryCellWithLike.nib
        tableView.register(nib, forCellReuseIdentifier: "RepositoryCell")
    }
}

extension LikesViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
        presenter.likesOutput = self
        presenter.collectLikedRepos()
    }
}

extension LikesViewController: LikesPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData]) {
        self.viewDataArray = viewDataArray
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension LikesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを表示
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell",
                                                 for: indexPath) as! RepositoryCellWithLike
        cell.configure(with: viewDataArray[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension LikesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = viewDataArray[indexPath.row]
        // お気に入り状態をトグル
        presenter.set(liked: !viewData.isLiked, for: viewData.id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

