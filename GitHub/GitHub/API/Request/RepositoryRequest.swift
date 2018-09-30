//
// Created by Kenji Tanaka on 2018/09/28.
// Copyright (c) 2018 marty-suzuki. All rights reserved.
//

import Foundation

/// - seealso: https://developer.github.com/v3/repos/#get
public struct RepositoryRequest: Request {
    public typealias Response = Repository

    public let method: HttpMethod = .get
    public var path: String {
        return "/users/\(username)/\(repositoryName)"
    }

    public let username: String
    public let repositoryName: String

    public init(username: String, repositoryName: String) {
        self.username = username
        self.repositoryName = repositoryName
    }
}
