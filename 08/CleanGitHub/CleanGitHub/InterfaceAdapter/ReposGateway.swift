//
//  ReposGateway.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol WebClientProtocol {
    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> Void)
}

class ReposGateway: ReposGatewayProtocol {

    private weak var useCase: ReposLikesUseCaseProtocol!
    var webClient: WebClientProtocol!
    var dataStore: DataStoreProtocol!

    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetch(using keywords: [String], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        // キャッシュとして保存した上でGatewayの外側へ処理を伝える
        webClient.fetch(using: keywords) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let repos):
                self.dataStore.save(repos: repos, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> Void) {
        // Gatewayの外側へ処理を伝える
        dataStore.fetch(using: ids, completion: completion)
    }
}
