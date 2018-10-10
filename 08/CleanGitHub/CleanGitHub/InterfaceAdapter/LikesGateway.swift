//
//  LikesGateway.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol DataStoreProtocol: AnyObject {
    func fetch(ids: [GitHubRepo.ID],
               completion: (Result<[GitHubRepo.ID: Bool]>) -> Void)
    func save(liked: Bool,
              for id: GitHubRepo.ID,
              completion: (Result<Bool>) -> Void)
}

class LikesGateway: LikesGatewayProtocol {

    private var useCase: ReposLikesUseCaseProtocol
    weak var dataStore: DataStoreProtocol!

    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetch(ids: [GitHubRepo.ID],
               completion: (Result<[GitHubRepo.ID: Bool]>) -> Void) {
        dataStore.fetch(ids: ids, completion: completion)
    }

    func save(liked: Bool,
              for id: GitHubRepo.ID,
              completion: (Result<Bool>) -> Void) {
        dataStore.save(liked: liked, for: id, completion: completion)
    }
}
