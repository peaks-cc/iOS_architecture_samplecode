//
//  RepoStatusList.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/22.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

struct GitHubRepoStatus: Equatable {
    let repo: GitHubRepo
    let isLiked: Bool

    static func == (lhs: GitHubRepoStatus, rhs: GitHubRepoStatus) -> Bool {
        return lhs.repo == rhs.repo
    }
}

extension Array where Element == GitHubRepoStatus {
    init(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool]) {
        self = repos.map { repo in
            GitHubRepoStatus(
                repo: repo,
                isLiked: likes[repo.id] ?? false
            )
        }
    }
}

enum UniqueStrategy {
    case ignoreNewOne
    case replaceByNewOne
    case removeOldOne
}
extension Array where Element: Equatable {
    func unique(resolve: (Element, Element) -> UniqueStrategy) -> [Element] {
        return reduce(into: []) { (result, newOne) in
            switch result.firstIndex(of: newOne) {
            case .none:
                result.append(newOne)
            case let prevIndex?:
                let prev = result[prevIndex]
                switch resolve(prev, newOne) {
                case .ignoreNewOne:
                    ()
                case .replaceByNewOne:
                    result[prevIndex] = newOne
                case .removeOldOne:
                    result.remove(at: prevIndex)
                    result.append(newOne)
                }
            }
        }
    }
}

struct GitHubRepoStatusList {
    enum Error: Swift.Error {
        case notFoundRepo(ofID: GitHubRepo.ID)
    }
    private(set) var statuses: [GitHubRepoStatus]

    init(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool]) {
        statuses = Array(repos: repos, likes: likes)
            .unique(resolve: { _, _ in .ignoreNewOne })
    }
    mutating func append(repos: [GitHubRepo], likes: [GitHubRepo.ID: Bool]) {
        let newStatusesMayNotUnique = statuses + Array(repos: repos, likes: likes)
        statuses = newStatusesMayNotUnique
                .unique { _, _ in .removeOldOne }
    }
    mutating func set(isLiked: Bool, for id: GitHubRepo.ID) throws {
        guard let index = statuses.firstIndex(where: { $0.repo.id == id }) else {
            throw Error.notFoundRepo(ofID: id)
        }
        let currentStatus = statuses[index]
        statuses[index] = GitHubRepoStatus(
            repo: currentStatus.repo,
            isLiked: isLiked
        )
    }
    subscript(id: GitHubRepo.ID) -> GitHubRepoStatus? {
        return statuses.first(where: { $0.repo.id == id })
    }
}
