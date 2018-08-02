//
//  UserReposRequest.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

/// - seealso: https://developer.github.com/v3/repos/#list-user-repositories
public struct UserReposRequest: Request {
    public typealias Response = [Repository]

    public let method: HttpMethod = .get
    public var path: String {
        return "/users/\(username)/repos"
    }

    public var queryParameters: [String : String]? {
        var params: [String: String] = [:]
        if let page = page {
            params["page"] = "\(page)"
        }
        if let perPage = perPage {
            params["per_page"] = "\(perPage)"
        }
        if let sort = sort {
            params["sort"] = sort.rawValue
        }
        if let type = type {
            params["type"] = type.rawValue
        }
        if let direction = direction {
            params["direction"] = direction.rawValue
        }
        return params
    }

    public let username: String
    public let type: UserType?
    public let sort: Sort?
    public let direction: Direction?
    public let page: Int?
    public let perPage: Int?

    public init(username: String, type: UserType?, sort: Sort?, direction: Direction?, page: Int?, perPage: Int?) {
        self.username = username
        self.type = type
        self.sort = sort
        self.direction = direction
        self.page = page
        self.perPage = perPage
    }
}

extension UserReposRequest {
    public enum UserType: String {
        case all
        case owner
        case member
    }

    public enum Sort: String {
        case created
        case updated
        case pushed
        case fullName = "full_name"
    }

    public enum Direction: String {
        case desc
        case asc
    }
}
