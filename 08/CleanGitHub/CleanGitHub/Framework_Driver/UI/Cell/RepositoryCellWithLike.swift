//
//  RepositoryCell.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class RepositoryCellWithLike: UITableViewCell {

    public class var identifier: String {
        return String(describing: self)
    }

    public class var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: self))
    }

    @IBOutlet public private(set) weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet public private(set) weak var repositoryNameLabel: UILabel!
    @IBOutlet public private(set) weak var descriptionLabel: UILabel!

    @IBOutlet public private(set) weak var languageContainerView: UIView!
    @IBOutlet public private(set) weak var languageLabel: UILabel!

    @IBOutlet public private(set) weak var starLabel: UILabel!

    @IBOutlet public private(set) weak var likedLabel: UILabel!

    func configure(with viewData: GitHubRepoViewData) {
        repositoryNameLabel.text = viewData.fullName

        descriptionLabel.isHidden = false
        descriptionLabel.text = viewData.description

        languageContainerView.isHidden = false
        languageLabel.text = viewData.language

        starLabel.text = "★ \(viewData.stargazersCount)"

        likedLabel.text = viewData.isLiked ? "❤️" : "♡"
    }
}
