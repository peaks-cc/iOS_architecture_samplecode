//
//  ReposPresenter.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

// 画面表示用のデータ
struct GitHubRepoViewData {
    let id: String
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int
    let isLiked: Bool
}

protocol ReposPresenterProtocol: AnyObject {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func requestLikedRepos()

    // お気に入りの設定・解除
    func set(liked: Bool, for id: String)

    var output: ReposPresenterOutput? { get set }
}

protocol ReposPresenterOutput {
    // 表示用のデータが変化したことを外側に通知
    func update(by viewDataArray: [GitHubRepoViewData])
}

class ReposPresenter: ReposPresenterProtocol, ReposLikesUseCaseOutput {

    private weak var useCase: ReposLikesUseCaseProtocol!
    var output: ReposPresenterOutput?

    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.output = self
    }

    func startFetch(using keywords: [String]) {
        // Use Caseに検索を依頼
        useCase.startFetch(using: keywords)
    }

    func requestLikedRepos() {
        useCase.requestLikedRepos()
    }

    func set(liked: Bool, for id: String) {
        useCase.set(liked: liked, for: GitHubRepo.ID(rawValue: id))
    }

    func useCaseDidUpdateStatuses(_ repoStatus: [GitHubRepoStatus]) {
        // Use Caseから届いたデータを外側で使うデータに変換してから伝える
        let viewDataArray = repoStatus.map {
            return GitHubRepoViewData(
                id: $0.repo.id.rawValue,
                fullName: $0.repo.fullName,
                description: $0.repo.description,
                language: $0.repo.language,
                stargazersCount: $0.repo.stargazersCount,
                isLiked: $0.isLiked)
        }
        DispatchQueue.main.async { [weak self] in
            self?.output?.update(by: viewDataArray)
        }
    }
    
    func useCaseDidReceiveError(_ error: Error) {
        // <#code#>
    }
    
}
