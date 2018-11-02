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

    func buildLayer(with window: UIWindow) {

        // -- Use Case
        useCase = ReposLikesUseCase()

        // -- Interface Adapters
        let reposPresenter = ReposPresenter(useCase: useCase)
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)

        // Use Caseとのバインド
        useCase.output = reposPresenter
        useCase.reposGateway = reposGateway
        useCase.likesGateway = likesGateway

        // -- Framework & Drivers
        let webClient = GitHubReposStub()
        let likesDataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)

        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        likesGateway.dataStore = likesDataStore

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()

        // PresenterをView Controllerに注入
        if let target = vc as? PresentersInjectable {
            target.inject(presenters: [reposPresenter])
        }

        window.rootViewController = vc
    }
}

protocol PresentersInjectable {
    func inject(presenters: [ReposPresenterProtocol])
}

protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
