//
//  UserRepositoriesViewController.swift
//  FluxPlusExample
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
    private lazy var viewModel = UserRepositoriesViewModel(flux: flux)
    private lazy var dataSource = UserRepositoriesDataSource(viewModel: viewModel)
    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux

        super.init(nibName: "UserRepositoriesViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(tableView)

        viewModel.title
            .bind(to: Binder(self) { me, title in
                me.title = title
            })
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.showRepositoryDetail
            .bind(to: Binder(self) { me, _ in
                let vc = RepositoryDetailViewController()
                me.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
