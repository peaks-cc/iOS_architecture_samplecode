//
//  UserRepositoriesViewController.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import UIKit
import RxCocoa
import RxSwift

final class UserRepositoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let userStore: GitHubUserStore
    private let userActionCreator: GitHubUserActionCreator
    private let repositoryStore: GitHubRepositoryStore
    private let repositoryActionCreator: GitHubRepositoryActionCreator

    private let dataSource: UserRepositoriesDataSource
    private let disposeBag = DisposeBag()

    deinit {
        userActionCreator.setSelectedUser(nil)
        repositoryActionCreator.clearRepositories()
    }

    init(userStore: GitHubUserStore = .shared,
         userActionCreator: GitHubUserActionCreator = .shared,
         repositoryStore: GitHubRepositoryStore = .shared,
         repositoryActionCreator: GitHubRepositoryActionCreator = .shared) {
        self.userStore = userStore
        self.userActionCreator = userActionCreator
        self.repositoryStore = repositoryStore
        self.repositoryActionCreator = repositoryActionCreator
        self.dataSource = UserRepositoriesDataSource(repositoryStore: repositoryStore,
                                                     userStore: userStore,
                                                     actionCreator: repositoryActionCreator)

        super.init(nibName: "UserRepositoriesViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = userStore.selectedUser else {
            return
        }

        title = user.login

        dataSource.configure(tableView)

        repositoryStore.repositoriesObservable
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        repositoryStore.selectedRepositoryObservable
            .flatMap { repository -> Observable<Void> in
                repository == nil ? .empty() : .just(())
            }
            .bind(to: Binder(self) { me, _ in
                let vc = RepositoryDetailViewController()
                me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        repositoryActionCreator.fetchRepositories(username: user.login)
    }
}
