//
// User.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct User: Codable, Equatable, Hashable {

    public var avatarUrl: String?
    public var bio: String?
    public var blog: String?
    public var collaborators: Int?
    public var company: String?
    /** ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ */
    public var createdAt: String
    public var diskUsage: Int?
    public var email: String
    public var followers: Int
    public var following: Int
    public var gravatarId: String?
    public var hireable: Bool?
    public var htmlUrl: String?
    public var id: Int
    public var location: String?
    public var login: String
    public var name: String?
    public var ownedPrivateRepos: Int?
    public var privateGists: Int?
    public var publicGists: Int
    public var publicRepos: Int
    public var totalPrivateRepos: Int?
    public var type: String
    public var url: String

    public init(avatarUrl: String? = nil, bio: String? = nil, blog: String? = nil, collaborators: Int? = nil, company: String? = nil, createdAt: String, diskUsage: Int? = nil, email: String, followers: Int, following: Int, gravatarId: String? = nil, hireable: Bool? = nil, htmlUrl: String? = nil, id: Int, location: String? = nil, login: String, name: String? = nil, ownedPrivateRepos: Int? = nil, privateGists: Int? = nil, publicGists: Int, publicRepos: Int, totalPrivateRepos: Int? = nil, type: String, url: String) {
        self.avatarUrl = avatarUrl
        self.bio = bio
        self.blog = blog
        self.collaborators = collaborators
        self.company = company
        self.createdAt = createdAt
        self.diskUsage = diskUsage
        self.email = email
        self.followers = followers
        self.following = following
        self.gravatarId = gravatarId
        self.hireable = hireable
        self.htmlUrl = htmlUrl
        self.id = id
        self.location = location
        self.login = login
        self.name = name
        self.ownedPrivateRepos = ownedPrivateRepos
        self.privateGists = privateGists
        self.publicGists = publicGists
        self.publicRepos = publicRepos
        self.totalPrivateRepos = totalPrivateRepos
        self.type = type
        self.url = url
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case avatarUrl = "avatar_url"
        case bio
        case blog
        case collaborators
        case company
        case createdAt = "created_at"
        case diskUsage = "disk_usage"
        case email
        case followers
        case following
        case gravatarId = "gravatar_id"
        case hireable
        case htmlUrl = "html_url"
        case id
        case location
        case login
        case name
        case ownedPrivateRepos = "owned_private_repos"
        case privateGists = "private_gists"
        case publicGists = "public_gists"
        case publicRepos = "public_repos"
        case totalPrivateRepos = "total_private_repos"
        case type
        case url
    }

}
