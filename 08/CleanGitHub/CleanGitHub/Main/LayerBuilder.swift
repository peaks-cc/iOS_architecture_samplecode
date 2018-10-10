//
//  LayerBuilder.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

class LayerBuilder {

    /// Shared instance
    static let shared = LayerBuilder()
    private init() {}

    // 最外周を公開プロパティとして保持
    var webClient: WebClientProtocol!
    var likesDataStore: DataStoreProtocol!

    func build() {
        // -- Use Case
        let usecase = ReposLikesUseCase()

        // -- Interface Adapters
        let usecaseOutput = ReposPresenter(useCase: usecase)
        let reposGateway = ReposGateway(useCase: usecase)
        let likesGateway = LikesGateway(useCase: usecase)

        // Use Caseとのバインド
        usecase.output = usecaseOutput
        usecase.reposGateway = reposGateway
        usecase.likesGateway = likesGateway

        // -- Framework & Drivers
        webClient = GitHubReposStub()
        likesDataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)

        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        likesGateway.dataStore = likesDataStore
    }
}
