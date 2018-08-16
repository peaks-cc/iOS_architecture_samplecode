//
//  SearchUsersViewController.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
import UIKit

final class SearchUsersViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!

    private let flux: Flux

    private lazy var viewModel = SearchUsersViewModel(searchText: searchBar.rx.text.asObservable(),
                                                      cancelButtonClicked: searchBar.rx.cancelButtonClicked.asObservable(),
                                                      textDidBeginEditing: searchBar.rx.textDidBeginEditing.asObservable(),
                                                      searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
                                                      flux: flux)

    private lazy var dataSource = SearchUsersDataSource(viewModel: viewModel)

    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux

        super.init(nibName: "SearchUsersViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Users"

        dataSource.configure(tableView)

        viewModel.reloadData
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isFieldEditing
            .bind(to: Binder(self) { me, isFieldEditing in
                UIView.animate(withDuration: 0.3) {
                    if isFieldEditing {
                        me.view.backgroundColor = .black
                        me.tableView.isUserInteractionEnabled = false
                        me.tableView.alpha = 0.5
                        me.searchBar.setShowsCancelButton(true, animated: true)
                    } else {
                        me.searchBar.resignFirstResponder()
                        me.view.backgroundColor = .white
                        me.tableView.isUserInteractionEnabled = true
                        me.tableView.alpha = 1
                        me.searchBar.setShowsCancelButton(false, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.showUserRepositories
            .bind(to: Binder(self) { me, _ in
                let vc = UserRepositoriesViewController()
                me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
