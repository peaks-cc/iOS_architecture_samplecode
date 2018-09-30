//
//  SearchUsersViewController.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
import UIKit

final class RepositorySearchViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!

    private let actionCreator: ActionCreator
    private let searchStore: SearchRepositoryStore
    private let selectedStore: SelectedRepositoryStore

    private let dataSource: RepositorySearchDataSource
    private let disposeBag = DisposeBag()

    init(actionCreator: ActionCreator = .init(),
         searchRepositoryStore: SearchRepositoryStore = .shared,
         selectedRepositoryStore: SelectedRepositoryStore = .shared) {
        self.searchStore = searchRepositoryStore
        self.actionCreator = actionCreator
        self.selectedStore = selectedRepositoryStore
        self.dataSource = RepositorySearchDataSource(actionCreator: actionCreator,
                                                     searchRepositoryStore: searchRepositoryStore)

        super.init(nibName: "RepositorySearchViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Repositories"

        dataSource.configure(tableView)

        searchStore.repositoriesObservable
            .map { _ in }
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        searchStore.isSearchFieldEditingObservable
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

        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [actionCreator] in
                actionCreator.setIsSearchFieldEditing(false)
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [actionCreator] in
                actionCreator.setIsSearchFieldEditing(true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .subscribe(onNext: { [actionCreator] text in
                if let text = text, !text.isEmpty {
                    actionCreator.clearRepositories()
                    actionCreator.searchRepositories(query: text)
                    actionCreator.setIsSearchFieldEditing(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
