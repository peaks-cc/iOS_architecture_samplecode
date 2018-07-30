//
//  Github.ItemsResponse.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

extension Github {
    struct ItemsResponse<Item: Decodable>: Decodable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [Item]

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case incompleteResults = "incomplete_results"
            case items
        }
    }
}
