//
//  GitHubRepos.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/11/03.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation
import GitHub

class GitHubRepos: WebClientProtocol {

    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        let query = keywords.joined(separator: " ")
        let session = GitHub.Session()
        let request = SearchRepositoriesRequest(query: query,
                                                sort: nil,
                                                order: nil,
                                                page: nil, perPage: nil)

        session.send(request) { result in
            switch result {
            case .success(let response):
                let repos = response.0.items.map {
                    GitHubRepo.init(repository: $0)
                }
                completion(.success(repos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension GitHubRepo {
    init(repository: Repository) {
        self.init(id: GitHubRepo.ID(rawValue: String(repository.id)),
                  fullName: repository.fullName,
                  description: repository.description ?? "",
                  language: repository.language ?? "",
                  stargazersCount: repository.stargazersCount)
    }
}
