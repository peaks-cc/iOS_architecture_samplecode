//
//  FavoritesViewController.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import UIKit
import RxCocoa
import RxSwift

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let flux: Flux
    private lazy var viewModel = FavoritesViewModel(flux: flux)
    private lazy var dataSource = FavoritesDataSource(favorites: viewModel.favorites,
                                                      selectedIndexPath: { [weak viewModel] in viewModel?.selectedIndexPath($0) })

    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux

        super.init(nibName: "FavoritesViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        dataSource.configure(tableView)

        viewModel.reloadFavorites
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

