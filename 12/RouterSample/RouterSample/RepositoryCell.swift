//
//  RepositoryCell.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/26.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import GitHub

class RepositoryCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!

    func configure(repository: Repository) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        languageLabel.text = repository.language
        starLabel.text = "star: \(repository.stargazersCount)"
        forkLabel.text = "fork: \(repository.forksCount)"
    }
}
