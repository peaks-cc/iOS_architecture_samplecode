//
//  ReposLikesUseCase.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

// Use Caseが外側(Interface Adapters)に公開するインターフェイス
protocol ReposLikesUseCaseProtocol: AnyObject {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func collectLikedRepos()
    // お気に入りの追加・削除
    func set(liked: Bool, for repo: GitHubRepo.ID)

    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReposLikesUseCaseOutput! { get set }
    var reposGateway: ReposGatewayProtocol! { get set }
    var likesGateway: LikesGatewayProtocol! { get set }
}

protocol ReposLikesUseCaseOutput {
    // GitHubリポジトリ（＋お気に入りON/OFF）の情報が更新されたときに呼ばれる
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus])
    // お気に入り一覧情報が更新されたときに呼ばれる
    func useCaseDidUpdateLikesList(_ likesList: [GitHubRepoStatus])
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

protocol ReposGatewayProtocol {
    // キーワードで検索した結果を完了ハンドラで返す
    func fetch(using keywords: [String],
               completion: @escaping (Result<[GitHubRepo]>) -> Void)

    // IDで検索した結果を完了ハンドラで返す
    func fetch(using ids: [GitHubRepo.ID],
               completion: @escaping (Result<[GitHubRepo]>) -> Void)
}

protocol LikesGatewayProtocol {
    // IDで検索したお気に入りの結果を完了ハンドラで返す
    func fetch(ids: [GitHubRepo.ID],
               completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> Void)
    // IDについてのお気に入り状態を保存する
    func save(liked: Bool,
              for id: GitHubRepo.ID,
              completion: @escaping (Result<Bool>) -> Void)
    // お気に入り情報の一覧を返す
    func allLikes(completion: @escaping (Result<[GitHubRepo.ID: Bool]>) -> Void)
}

// Use Caseの実装
final class ReposLikesUseCase: ReposLikesUseCaseProtocol {

    var output: ReposLikesUseCaseOutput!

    var reposGateway: ReposGatewayProtocol!
    var likesGateway: LikesGatewayProtocol!

    private var statusList = GitHubRepoStatusList(repos: [], likes: [:])
    private var likesList = GitHubRepoStatusList(repos: [], likes: [:])

    // キーワードでリポジトリを検索し、結果とお気に入り状態を組み合わせた結果をOutputに通知する
    func startFetch(using keywords: [String]) {

        reposGateway.fetch(using: keywords) { [weak self] reposResult in
            guard let self = self else { return }

            switch reposResult {
            case .failure(let e):
                self.output
                    .useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
            case .success(let repos):
                let ids = repos.map { $0.id }
                self.likesGateway
                    .fetch(ids: ids) { [weak self] likesResult in
                        guard let self = self else { return }
                        
                        switch likesResult {
                        case .failure(let e):
                            self.output
                                .useCaseDidReceiveError(
                                    FetchingError.failedToFetchLikes(e))
                        case .success(let likes):
                            // 結果を保持
                            let statusList = GitHubRepoStatusList(
                                repos: repos, likes: likes
                            )
                            self.statusList = statusList
                            self.output.useCaseDidUpdateStatuses(statusList.statuses)
                        }
                }
            }
        }
    }

    func collectLikedRepos() {
        likesGateway.allLikes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let e):
                self.output
                    .useCaseDidReceiveError(
                        FetchingError.failedToFetchLikes(e))
            case .success(let allLikes):
                let ids = Array(allLikes.keys)
                self.reposGateway.fetch(using: ids) { [weak self] reposResult in
                    guard let self = self else { return }

                    switch reposResult {
                    case .failure(let e):
                        self.output
                            .useCaseDidReceiveError(
                                FetchingError.failedToFetchLikes(e))
                    case .success(let repos):
                        // 結果を保持
                        let likesList = GitHubRepoStatusList(
                            repos: repos,
                            likes: allLikes,
                            trimmed: true
                        )
                        self.likesList = likesList
                        self.output.useCaseDidUpdateLikesList(likesList.statuses)
                    }
                }
            }

        }
    }

    func set(liked: Bool, for id: GitHubRepo.ID) {
        // お気に入りの状態を保存し、更新の結果を伝える
        likesGateway.save(liked: liked, for: id)
        { [weak self] likesResult in
            guard let self = self else { return }

            switch likesResult {
            case .failure:
                self.output
                    .useCaseDidReceiveError(SavingError.failedToSaveLike)
            case .success(let isLiked):
                do {
                    try self.statusList.set(isLiked: isLiked, for: id)
                    try self.likesList.set(isLiked: isLiked, for: id)
                    self.output
                        .useCaseDidUpdateStatuses(self.statusList.statuses)
                    self.output
                        .useCaseDidUpdateLikesList(self.likesList.statuses)
                } catch {
                    self.output
                        .useCaseDidReceiveError(SavingError.failedToSaveLike)
                }
            }
        }
    }
}
