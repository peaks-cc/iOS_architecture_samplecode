//
//  RepositoryTableViewCell.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var numberOfFalksLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        print(#function)
    }
}

