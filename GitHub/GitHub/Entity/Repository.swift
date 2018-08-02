//
//  Repository.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

public struct Repository: Codable {
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let owner: User
    public let isPrivate: Bool
    public let htmlURL: URL
    public let description: String?
    public let isFork: Bool
    public let url: URL
    public let createdAt: String
    public let updatedAt: String
    public let pushedAt: String
    public let homepage: String?
    public let size: Int
    public let stargazersCount: Int
    public let watchersCount: Int
    public let language: String?
    public let forksCount: Int
    public let openIssuesCount: Int
    public let defaultBranch: String

    private enum CodingKeys: String, CodingKey {
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
