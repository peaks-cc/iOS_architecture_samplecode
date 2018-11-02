//
//  Application.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import UIKit

class Application {

    /// Shared instance
    static let shared = Application()
    private init() {}

    // ユースケースを公開プロパティとして保持
    private(set) var useCase: ReposLikesUseCase!
    private(set) var reposPresenter: ReposPresenterProtocol!

    func buildLayer() {
        // -- Use Case
        useCase = ReposLikesUseCase()

        // -- Interface Adapters
        reposPresenter = ReposPresenter(useCase: useCase)
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)

        // Use Caseとのバインド
        if let presenter = reposPresenter as? ReposLikesUseCaseOutput {
            useCase.output = presenter
        }
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

protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
