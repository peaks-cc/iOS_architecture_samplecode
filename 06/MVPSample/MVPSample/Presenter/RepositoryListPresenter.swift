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
    var numberOfRepositories: Int {
        return repositories.count
    }

    func viewDidLoad() {
        gitHubClient.fetchRepositoryList { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories

                DispatchQueue.main.async {
                    self?.repositoryListViewController.reload()
                }
            case .error(let error):
                ()
            }
        }
    }

}
