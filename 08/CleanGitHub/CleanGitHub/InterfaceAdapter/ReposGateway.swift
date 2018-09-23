//
//  ReposGateway.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol ReposGatewayProtocol {
    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void)
    func fetch(using likes: [Like], completion: (Result<[GitHubRepo]>) -> Void)
}

class ReposGateway: ReposProtocol {
    
    var repository: ReposGatewayProtocol?
    
    init(repository: ReposGatewayProtocol?) {
        self.repository = repository
    }

    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void) {
        repository?.fetch(using: keywords, completion: completion)
    }
    
    func fetch(using likes: [Like], completion: (Result<[GitHubRepo]>) -> Void) {
        repository?.fetch(using: likes, completion: completion)
    }
    
}
