//
//  RepositoryListViewController.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import UIKit

class RepositoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let repositoryListPresenter = RepositoryListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryListPresenter.inject(repositoryListViewController: self)
        repositoryListPresenter.viewDidLoad()

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RepositoryTableViewCell")

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func reload() {
        tableView.reloadData()
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryListPresenter.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell") as! RepositoryTableViewCell
        cell.set(repository: repositoryListPresenter.repositories[indexPath.row])

        return cell
    }
}

