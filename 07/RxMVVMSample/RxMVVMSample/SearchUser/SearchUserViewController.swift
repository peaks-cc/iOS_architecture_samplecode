//
//  SearchUserViewController.swift
//  MVPSample
//
//  Created by Kenji Tanaka on 2018/09/23.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchUserViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel = SearchUserViewModel(
        searchBarText: searchBar.rx.text.asObservable(),
        searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable()
    )

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)

        viewModel.transitionToUserDetail
            .bind(to: transitionToUserDetail)
            .disposed(by: disposeBag)
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        let user = viewModel.users[indexPath.row]
        cell.configure(user: user)

        return cell
    }
}

extension SearchUserViewController {
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }

    private var transitionToUserDetail: Binder<(String)> {
        return Binder(self) { me, userName in
            let userDetailVC = UIStoryboard(name: "UserDetail", bundle: nil).instantiateInitialViewController() as! UserDetailViewController
            let model = UserDetailModel(userName: userName)
            let presenter = UserDetailPresenter(userName: userName, view: userDetailVC, model: model)
            userDetailVC.inject(presenter: presenter)

            me.navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
}
