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

    private var viewModel: SearchUserViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        viewModel = SearchUserViewModel(
            searchBarTextObs: searchBar.rx.text.asObservable(),
            searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
            itemSelected: tableView.rx.itemSelected.asObservable(),
            reloadData: reloadData,
            transitionToUserDetail: transitionToUserDetail
        )
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // FIXME: なんか最初viewModelがnilになる...
        // FIXME: ので、optionalにしてみた...
        return viewModel?.users.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        guard let user = viewModel?.users.value[indexPath.row] else { return cell }
        cell.configure(user: user)

        return cell
    }
}

extension SearchUserViewController {
    private var reloadData: AnyObserver<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
            }.asObserver()
    }

    private var transitionToUserDetail: AnyObserver<(String)> {
        return Binder(self) { me, userName in
            let userDetailVC = UIStoryboard(name: "UserDetail", bundle: nil).instantiateInitialViewController() as! UserDetailViewController
            let model = UserDetailModel(userName: userName)
            let presenter = UserDetailPresenter(userName: userName, view: userDetailVC, model: model)
            userDetailVC.inject(presenter: presenter)

            me.navigationController?.pushViewController(userDetailVC, animated: true)
            }.asObserver()
    }
}
