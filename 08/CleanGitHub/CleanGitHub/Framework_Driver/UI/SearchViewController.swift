//
//  SearchViewController.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/17.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit
import GitHub

class SearchViewController: UITableViewController {
    private weak var presenter: ReposPresenterProtocol! {
        didSet { viewDidInject() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func viewDidInject() {
        presenter.output = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
    }
}

extension SearchViewController: ReposPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData]) {
        //        <#code#>
    }
}

// MARK: UITableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: CGRect.zero)
    }
}

// MARK: UITableViewDelegate
extension SearchViewController {

}
