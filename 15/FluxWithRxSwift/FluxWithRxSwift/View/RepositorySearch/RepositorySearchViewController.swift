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

    private let searchStore: SearchRepositoryStore
    private let searchActionCreator: SearchRepositoryActionCreator
    private let selectedStore: SelectedRepositoryStore

    private let dataSource: RepositorySearchDataSource
    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.searchStore = flux.searchRepositoryStore
        self.searchActionCreator = flux.searchRepositoryActionCreator
        self.selectedStore = flux.selectedRepositoryStore
        self.dataSource = RepositorySearchDataSource(flux: flux)

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
            .subscribe(onNext: { [searchActionCreator] in
                searchActionCreator.setIsSearchFieldEditing(false)
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [searchActionCreator] in
                searchActionCreator.setIsSearchFieldEditing(true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .subscribe(onNext: { [searchActionCreator] text in
                if let text = text, !text.isEmpty {
                    searchActionCreator.clearRepositories()
                    searchActionCreator.searchRepositories(query: text)
                    searchActionCreator.setIsSearchFieldEditing(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
