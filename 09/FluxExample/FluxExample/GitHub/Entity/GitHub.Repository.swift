//
//  GitHub.Repository.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

extension GitHub {
    struct Repository: Codable {
        let id: Int
        let nodeID: String
        let name: String
        let fullName: String
        let owner: User
        let isPrivate: Bool
        let htmlURL: URL
        let description: String?
        let isFork: Bool
        let url: URL
        let createdAt: String
        let updatedAt: String
        let pushedAt: String
        let homepage: String?
        let size: Int
        let stargazersCount: Int
        let watchersCount: Int
        let language: String?
        let forksCount: Int
        let openIssuesCount: Int
        let defaultBranch: String

        enum CodingKeys: String, CodingKey {
            case id
            case nodeID = "node_id"
            case name
            case fullName = "full_name"
            case owner
            case isPrivate = "private"
            case htmlURL = "html_url"
            case description
            case isFork = "fork"
            case url
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case pushedAt = "pushed_at"
            case homepage
            case size
            case stargazersCount = "stargazers_count"
            case watchersCount = "watchers_count"
            case language
            case forksCount = "forks_count"
            case openIssuesCount = "open_issues_count"
            case defaultBranch = "default_branch"
        }
    }
}
