//
//  ItemsResponse.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public struct ItemsResponse<Item: Decodable>: Decodable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [Item]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

    public init(totalCount: Int, incompleteResults: Bool, items: [Item]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
}
