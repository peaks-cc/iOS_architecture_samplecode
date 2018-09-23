//
//  RepoStatusList.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/22.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

struct RepoStatus {
    let repo: GitHubRepo
    let like: Like?
}

struct RepoStatusList {
    enum Error: Swift.Error {
        case notFoundRepo(ofID: String)
    }

    private var repos = [GitHubRepo]()
    var likes = [Like]()

    mutating func register(repos: [GitHubRepo]) {
        self.repos = repos
    }
    mutating func register(likes: [Like]) {
        self.likes = likes
    }

    mutating func likeRepo(of id: String) throws {
        try set(isLiked: true, of: id)
    }
    mutating func unlikeRepo(of id: String) throws {
        try set(isLiked: false, of: id)
    }

    private mutating func set(isLiked: Bool, of id: String) throws {
        guard repos.contains(where: { $0.id == id }) else {
            throw Error.notFoundRepo(ofID: id)
        }
        let newLike = Like(id: id, isLiked: isLiked)
        // お気に入り情報がない場合は新しく追加
        if let index = likes.firstIndex(where: { $0.id == id }) {
            likes[index] = newLike
        } else {
            likes.append(newLike)
        }
    }

    func status(of id: String) throws -> RepoStatus {
        guard let repo = repos.first(where: { $0.id == id }) else {
            throw Error.notFoundRepo(ofID: id)
        }
        return RepoStatus(repo: repo,
                          like: likes.first(where: { $0.id == id }))
    }

    var allStatus: [RepoStatus] {
        return repos.map{ repo in
            RepoStatus(repo: repo,
                       like: likes.first(where: { $0.id == repo.id}))
        }
    }
}
