//
//  Repository.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/24.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let fullName: String
    let numberOfIssues: Int
    let numberOfForks: Int

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case numberOfIssues = "open_issues_count"
        case numberOfForks = "forks_count"
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.numberOfIssues == rhs.numberOfIssues && lhs.numberOfForks == rhs.numberOfForks
    }
}
