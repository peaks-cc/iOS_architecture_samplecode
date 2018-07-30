//
//  GitHubGateway.swift
//  CleanArchitectureExample
//
//  Created by Daiki Matsudate on 2018/07/22.
//  Copyright © 2018 Daiki Matsudate. All rights reserved.
//

import Foundation
import RxSwift

struct GitHub {
    static let baseURL = URL(string: "https://api.github.com")!

    enum Endpoint: String {
        case searchRepositories = "/search/repositories"
        case searchCommits      = "/search/commits"
        case searchCode         = "/search/code"

        var url: URL {
            return GitHub.baseURL.appendingPathComponent(self.rawValue)
        }
    }

    enum SearchRepositoriesSort: String {
        case start
        case forks
        case update
    }

    enum SearchCommitsSort: String {
        case authorDate = "author-date"
        case committerDate = "committer-date"
    }

    enum SearchCodeSort: String {
        case indexed
    }

    enum Order: String {
        case desc
        case asc
    }
}

protocol GitHubGateway {
    func search(repositories q: String,
                sort: GitHub.SearchRepositoriesSort?,
                order: GitHub.Order) -> Observable<Response<GitHubRepoEntity>>
    func search(commits q: String,
                sort: GitHub.SearchCommitsSort?,
                order: GitHub.Order) -> Observable<Response<GitHubRepoEntity>>
    func search(code q: String,
                sort: GitHub.SearchCodeSort?,
                order: GitHub.Order) -> Observable<Response<GitHubRepoEntity>>
}
