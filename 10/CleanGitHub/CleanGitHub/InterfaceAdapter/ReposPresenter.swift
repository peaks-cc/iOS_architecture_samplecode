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

// 外側(Viewなど)にPresenterが公開するインターフェイス
protocol ReposPresenterProtocol: AnyObject {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func collectLikedRepos()

    // お気に入りの設定・解除
    func set(liked: Bool, for id: String)

    var reposOutput: ReposPresenterOutput? { get set }
    var likesOutput: LikesPresenterOutput? { get set }
}

// GitHubリポジトリの検索View向け出力インターフェイス
protocol ReposPresenterOutput {
    // 表示用のデータが変化したことをPresenterから外側に通知
    func update(by viewDataArray: [GitHubRepoViewData])
}

// GitHubリポジトリのお気に入り一覧View向け出力インターフェイス
protocol LikesPresenterOutput {
    // 表示用のデータが変化したことをPresenterから外側に通知
    func update(by viewDataArray: [GitHubRepoViewData])
}

// Presenterの実装
class ReposPresenter: ReposPresenterProtocol, ReposLikesUseCaseOutput {

    private weak var useCase: ReposLikesUseCaseProtocol!
    var reposOutput: ReposPresenterOutput?
    var likesOutput: LikesPresenterOutput?

    init(useCase: ReposLikesUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.output = self
    }

    func startFetch(using keywords: [String]) {
        // Use Caseに検索を依頼
        useCase.startFetch(using: keywords)
    }

    func collectLikedRepos() {
        useCase.collectLikedRepos()
    }

    func set(liked: Bool, for id: String) {
        useCase.set(liked: liked, for: GitHubRepo.ID(rawValue: id))
    }

    func useCaseDidUpdateStatuses(_ repoStatus: [GitHubRepoStatus]) {
        // Use Caseから届いたデータを外側で使うデータに変換してから伝える
        let viewDataArray = Array.init(repoStatus: repoStatus)

        DispatchQueue.main.async { [weak self] in
            self?.reposOutput?.update(by: viewDataArray)
        }
    }

    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus]) {
        // Use Caseから届いたデータを外側で使うデータに変換してから伝える
        let viewDataArray = Array.init(repoStatus: likesList)

        DispatchQueue.main.async { [weak self] in
            self?.likesOutput?.update(by: viewDataArray)
        }
    }

    func useCaseDidReceiveError(_ error: Error) {
        // <#code#>
    }
}

extension Array where Element == GitHubRepoViewData {
    init(repoStatus: [GitHubRepoStatus]) {
        self = repoStatus.map {
            return GitHubRepoViewData(
                id: $0.repo.id.rawValue,
                fullName: $0.repo.fullName,
                description: $0.repo.description,
                language: $0.repo.language,
                stargazersCount: $0.repo.stargazersCount,
                isLiked: $0.isLiked)
        }
    }
}
