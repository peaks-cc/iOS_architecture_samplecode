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

    func configure(with window: UIWindow) {
        buildLayer()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }

    private func buildLayer() {

        // -- Use Case
        useCase = ReposLikesUseCase()

        // -- Interface Adapters
        let reposGateway = ReposGateway(useCase: useCase)
        let likesGateway = LikesGateway(useCase: useCase)

        // Use Caseとのバインド
        useCase.reposGateway = reposGateway
        useCase.likesGateway = likesGateway

        // -- Framework & Drivers
        let webClient = GitHubRepos()
        let likesDataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)

        // Interface Adaptersとのバインド
        reposGateway.webClient = webClient
        reposGateway.dataStore = likesDataStore
        likesGateway.dataStore = likesDataStore

        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
        // (本プロジェクトではTabBarControllerのawakeFromNib())
    }
}

protocol ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol)
}
