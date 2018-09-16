//
//  GitHubRepositoryCell.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import GitHub

final class GitHubRepositoryCell: UITableViewCell {

    class var identifier: String {
        return String(describing: self)
    }

    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var languageContainerView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!

    @IBOutlet private weak var starLabel: UILabel!

    func configure(with repository: GitHub.Repository) {
        repositoryNameLabel.text = repository.fullName

        if let description = repository.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
            descriptionLabel.text = nil
        }

        if let language = repository.language {
            languageContainerView.isHidden = false
            languageLabel.text = language
        } else {
            languageContainerView.isHidden = true
            languageLabel.text = nil
        }

        starLabel.text = "★ \(repository.stargazersCount)"
    }
}
