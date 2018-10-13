//
//  RepositoryDetailViewController.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/28.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

// - RepositoryDetailViewController
//   - View
//     - UserView
//     - Description
//     - Contributors
//     - SeeMoreDetail
//   - Feature
//     - transitionToUserDetail
//     - transitionToRepositoryDetail

protocol RepositoryDetailViewProtocol where Self: UIViewController {

}

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!
    @IBOutlet weak var contributorsView: UIView!
    @IBOutlet weak var seeMoreDetailView: UIButton!

    private var presenter: RepositoryDetailPresenterProtocol!
    func inject(presenter: RepositoryDetailPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    @IBAction func didTapSeeMoreDetailButton(_ sender: Any) {

    }
}

extension RepositoryDetailViewController: RepositoryDetailViewProtocol {
    
}



