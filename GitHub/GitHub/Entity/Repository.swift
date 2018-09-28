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
    public let contributorsURL: URL
    public let description: String?
    public let isFork: Bool
    public let url: URL
    public let createdAt: String
    public let updatedAt: String
    public let pushedAt: String?
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
        case contributorsURL = "contributors_url"
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

    public init(id: Int,
                nodeID: String,
                name: String,
                fullName: String,
                owner: User,
                isPrivate: Bool,
                htmlURL: URL,
                contributorsURL: URL,
                description: String?,
                isFork: Bool,
                url: URL,
                createdAt: String,
                updatedAt: String,
                pushedAt: String?,
                homepage: String?,
                size: Int,
                stargazersCount: Int,
                watchersCount: Int,
                language: String?,
                forksCount: Int,
                openIssuesCount: Int,
                defaultBranch: String) {
        self.id = id
        self.nodeID = nodeID
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.isPrivate = isPrivate
        self.htmlURL = htmlURL
        self.contributorsURL = contributorsURL
        self.description = description
        self.isFork = isFork
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
        self.homepage = homepage
        self.size = size
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.language = language
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.defaultBranch = defaultBranch
    }
}
