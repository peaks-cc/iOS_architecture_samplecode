//
//  RepositoryListPresenter.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

class RepositoryListPresenter {

    private weak var repositoryListViewController: RepositoryListViewController!
    private let gitHubClient = GitHubClient()

    func inject(repositoryListViewController: RepositoryListViewController) {
        self.repositoryListViewController = repositoryListViewController
    }

    private(set) var repositories: [Repository] = []

    func viewDidLoad() {
        gitHubClient.fetchRepositoryList { [weak self] repositories in
            DispatchQueue.main.async {
                self?.repositories = repositories
                self?.repositoryListViewController.reload()
            }
        }
    }

}
