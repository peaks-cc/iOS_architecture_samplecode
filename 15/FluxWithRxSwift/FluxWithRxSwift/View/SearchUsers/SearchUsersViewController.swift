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

final class SearchUsersViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!

    private let flux: Flux
    private let dataSource: SearchUsersDataSource
    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux
        self.dataSource = SearchUsersDataSource(flux: flux)

        super.init(nibName: "SearchUsersViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Users"

        dataSource.configure(tableView)

        let store = flux.userStore
        let actionCreator = flux.userActionCreator

        store.usersObservable
            .map { _ in }
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        store.isFieldEditingObservable
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

        store.selectedUserObservable
            .flatMap { user -> Observable<Void> in
                user == nil ? .empty() : .just(())
            }
            .bind(to: Binder(self) { me, _ in
                let vc = UserRepositoriesViewController()
                me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: {
                actionCreator.setIsSearchUsersFieldEditing(false)
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: {
                actionCreator.setIsSearchUsersFieldEditing(true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .subscribe(onNext: { text in
                if let text = text, !text.isEmpty {
                    actionCreator.clearUsers()
                    actionCreator.searchUsers(query: text)
                    actionCreator.setIsSearchUsersFieldEditing(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
