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

    private let flux: Flux

    private let dataSource: UserRepositoriesDataSource
    private let disposeBag = DisposeBag()

    deinit {
        flux.userActionCreator.setSelectedUser(nil)
        flux.repositoryActionCreator.clearRepositories()
    }

    init(flux: Flux = .shared) {
        self.flux = flux
        self.dataSource = UserRepositoriesDataSource(flux: flux)

        super.init(nibName: "UserRepositoriesViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = flux.userStore.selectedUser else {
            return
        }

        title = user.login

        dataSource.configure(tableView)

        flux.repositoryStore.repositoriesObservable
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        flux.repositoryStore.selectedRepositoryObservable
            .flatMap { repository -> Observable<Void> in
                repository == nil ? .empty() : .just(())
            }
            .bind(to: Binder(self) { me, _ in
                let vc = RepositoryDetailViewController()
                me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        flux.repositoryActionCreator.fetchRepositories(username: user.login)
    }
}
