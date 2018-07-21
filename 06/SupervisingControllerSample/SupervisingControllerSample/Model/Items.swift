//
//  Items.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

struct Items: Decodable {
    let repositories: [Repository]

    private enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}
