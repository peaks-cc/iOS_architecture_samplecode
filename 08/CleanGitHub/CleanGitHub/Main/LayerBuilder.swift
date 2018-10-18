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

    // ユースケースを公開プロパティとして保持
    var useCase: ReposLikesUseCase!

    func build() {
        // -- Use Case
        useCase = ReposLikesUseCase()

        // -- Interface Adapters
        let usecaseOutput = ReposPresenter(useCase: useCase)
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)

        // Use Caseとのバインド
        useCase.output = usecaseOutput
        useCase.reposGateway = reposGateway
        useCase.likesGateway = likesGateway

        // -- Framework & Drivers
        let webClient = GitHubReposStub()
        let likesDataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)

        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        likesGateway.dataStore = likesDataStore
    }
}
