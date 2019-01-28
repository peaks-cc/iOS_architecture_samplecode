//
//  RepositorySearchViewController.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
import UIKit

final class RepositorySearchViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!

    private let flux: Flux

    private lazy var viewModel = RepositorySearchViewModel(searchText: searchBar.rx.text.asObservable(),
                                                           cancelButtonClicked: searchBar.rx.cancelButtonClicked.asObservable(),
                                                           textDidBeginEditing: searchBar.rx.textDidBeginEditing.asObservable(),
                                                           searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
                                                           flux: flux)

    private lazy var dataSource = RepositorySearchDataSource(repositories: viewModel.repositories,
                                                             selectedIndexPath: { [weak viewModel] in viewModel?.selectedIndexPath($0) },
                                                             reachBottom: { [weak viewModel] in viewModel?.reachBottom() })

    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux

        super.init(nibName: "RepositorySearchViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Repositories"

        dataSource.configure(tableView)

        viewModel.reloadRepositories
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.editingLayout
            .bind(to: Binder(self) { me, _ in
                UIView.animate(withDuration: 0.3) {
                    me.view.backgroundColor = .black
                    me.tableView.isUserInteractionEnabled = false
                    me.tableView.alpha = 0.5
                    me.searchBar.setShowsCancelButton(true, animated: true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.nonEditingLayout
            .bind(to: Binder(self) { me, _ in
                UIView.animate(withDuration: 0.3) {
                    me.searchBar.resignFirstResponder()
                    me.view.backgroundColor = .white
                    me.tableView.isUserInteractionEnabled = true
                    me.tableView.alpha = 1
                    me.searchBar.setShowsCancelButton(false, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
