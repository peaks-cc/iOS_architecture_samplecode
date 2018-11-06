//
//  GitHubRepo.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

struct GitHubRepo: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: String
    }
    let id: ID
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int

    public static func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
        return lhs.id == rhs.id
    }
}
