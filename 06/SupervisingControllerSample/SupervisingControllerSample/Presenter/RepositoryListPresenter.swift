//
//  RepositoryListPresenter.swift
//  SupervisingControllerSample
//
//  Created by Kenji Tanaka on 2018/07/21.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import Foundation

class RepositoryListPresenter {
    private weak var repositoryListViewController: RepositoryListViewController!
    private let gitHubClient = GitHubClient()

    var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.repositoryListViewController.reload()
            }
        }
    }

    var numberOfRepositories: Int {
        return repositories.count
    }

    func inject(repositoryListViewController: RepositoryListViewController) {
        self.repositoryListViewController = repositoryListViewController
    }

    func viewDidLoad() {
        getRepositoryList()
    }

    private func getRepositoryList() {
        gitHubClient.fetchRepositoryList { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
            case .error(let error):
                ()
            }
        }
    }
}
