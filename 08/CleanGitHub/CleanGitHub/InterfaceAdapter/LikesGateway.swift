//
//  LikesGateway.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol LikesGatewayProtocol {
    func fetch(byNames names: [String], completion: (Result<[Like]>) -> Void)
    func save(liked: Bool, for repo: GitHubRepo, completion: (Result<Like>) -> Void)
}

class LikesGateway: LikesProtocol {
    
    var repository: LikesGatewayProtocol?

    init(repository: LikesGatewayProtocol?) {
        self.repository = repository
    }

    func fetch(byNames names: [String], completion: (Result<[Like]>) -> Void) {
        repository?.fetch(byNames: names, completion: completion)
    }
    
    func save(liked: Bool, for repo: GitHubRepo, completion: (Result<Like>) -> Void) {
        repository?.save(liked: liked, for: repo, completion: completion)
    }
    
}
