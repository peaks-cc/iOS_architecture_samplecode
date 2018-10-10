//
//  GitHubReposStub.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/26.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

class GitHubReposStub: ReposGatewayProtocol {
    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void) {
        // ダミーデータを作成して返す
        let repos = (0..<5).map{
            GitHubRepo(id: "repos/\($0)",
                fullName: "repos/\($0)",
                description: "my awesome project",
                language: "swift",
                stargazersCount: $0)
        }
        completion(.success(repos))
    }

    func fetch(using likes: [Like], completion: (Result<[GitHubRepo]>) -> Void) {
        //
    }
}
