//
//  UserCell.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/23.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import GitHub

class UserCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(user: User) {
        let url = user.avatarURL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let imageData = data {
                DispatchQueue.main.async { [weak self] in
                    self?.imageView?.image = UIImage(data: imageData)
                }
            }
        }
        task.resume()

        nameLabel.text = user.login
    }
}
