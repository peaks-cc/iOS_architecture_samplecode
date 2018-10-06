//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UserDetailViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    // FIXME: ViewControllerで使わいScreenStateが入ってしまうのが気持ちわるい。本来ViewModelが持っていればよいもの。
    // ただし外部からViewModelを注入する場合、tableViewがnilで落ちる...。
    var userName: String!
    private lazy var viewModel = UserDetailViewModel(
        userName: userName,
        itemSelected: tableView.rx.itemSelected.asObservable(),
        model: UserDetailModel(userName: userName))

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        viewModel.transitionToRepositoryDetail
            .bind(to: transitionToRepositoryDetail)
            .disposed(by: disposeBag)
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
    }
}

extension UserDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(repository: repository)
        return cell
    }
}

extension UserDetailViewController {
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }

    private var transitionToRepositoryDetail: Binder<(String, String)> {
        return Binder(self) { me, info in
            let userName = info.0
            let repositoryName = info.1

            let model = RepositoryDetailModel(userName: userName, repositoryName: repositoryName)
            let presenter = RepositoryDetailPresenter(userName: userName, repositoryName: repositoryName, model: model)
            let repositoryDetailVC = UIStoryboard(name: "RepositoryDetail", bundle: nil).instantiateInitialViewController() as! RepositoryDetailViewController
            repositoryDetailVC.inject(presenter: presenter)

            me.navigationController?.pushViewController(repositoryDetailVC, animated: true)
        }
    }
}
