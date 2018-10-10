//
//  ReposGateway.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol WebClientProtocol: AnyObject {
    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void)
}

class ReposGateway: ReposGatewayProtocol {

    private var useCase: ReposLikesUseCaseProtocol
    weak var webClient: WebClientProtocol!

    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void) {
        // 外側へ処理を伝える
        webClient.fetch(using: keywords, completion: completion)
    }
}
