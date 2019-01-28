//
//  SearchViewController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/17.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    private var viewDataArray = [GitHubRepoViewData]()
    private weak var presenter: ReposPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        searchBar.delegate = self

        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        let nib = RepositoryCellWithLike.nib
        tableView.register(nib, forCellReuseIdentifier: "RepositoryCell")
    }
}

extension SearchViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
        presenter.reposOutput = self
        presenter.startFetch(using: [])
    }
}

extension SearchViewController: ReposPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData]) {
        self.viewDataArray = viewDataArray
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension SearchViewController {
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
extension SearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = viewDataArray[indexPath.row]
        // お気に入り状態をトグル
        presenter.set(liked: !viewData.isLiked, for: viewData.id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let text = searchBar.text else {
            return
        }
        let keywords = text.split(separator: " ").map(String.init)
        presenter.startFetch(using: keywords)
    }
}
