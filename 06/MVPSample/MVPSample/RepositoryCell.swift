//
//  RepositoryCell.swift
//  MVPSample
//
//  Created by Kenji Tanaka on 2018/09/26.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import GitHub

final class RepositoryCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var falkLabel: UILabel!

    func configure(repository: Repository) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        languageLabel.text = repository.language
        starLabel.text = "star: \(repository.stargazersCount)"
        falkLabel.text = "falk: \(repository.forksCount)"
    }
}
