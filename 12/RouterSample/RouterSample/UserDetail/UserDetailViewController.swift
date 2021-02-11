//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit

protocol UserDetailViewProtocol: Transitioner {
    func reloadTableView()
}

final class UserDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var presenter: UserDetailPresenterProtocol!
    func inject(presenter: UserDetailPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        presenter.viewDidLoad()
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
    }
}

extension UserDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        if let repository = presenter.repository(forRow: indexPath.row) {
            cell.configure(repository: repository)
        }
        return cell
    }
}

extension UserDetailViewController: UserDetailViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}
