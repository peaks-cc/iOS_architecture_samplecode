//
//  ReposLikesUseCase.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol ReposLikesUseCaseProtocol {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func requestLikedRepos()
    // お気に入りの追加・削除
    func set(liked: Bool, for repo: GitHubRepo)

    // 外側のオブジェクトはプロパティとしてあとからセットする
    var output: ReposLikesUseCaseOutput! { get set }
    var reposGateway: ReposGatewayProtocol! { get set }
    var likesGateway: LikesGatewayProtocol! { get set }
}

protocol ReposLikesUseCaseOutput: AnyObject {
    // リポジトリとお気に入りとをペアにした情報が更新されたときに呼ばれる
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus])
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

protocol ReposGatewayProtocol: AnyObject {
    // キーワードで検索した結果を完了ハンドラで返す
    func fetch(using keywords: [String],
               completion: (Result<[GitHubRepo]>) -> Void)
}

protocol LikesGatewayProtocol: AnyObject {
    // IDで検索したお気に入りの結果を完了ハンドラで返す
    func fetch(ids: [GitHubRepo.ID],
               completion: (Result<[GitHubRepo.ID: Bool]>) -> Void)
    // IDについてのお気に入り状態を保存する
    func save(liked: Bool,
              for id: GitHubRepo.ID,
              completion: (Result<Bool>) -> Void)
}

final class ReposLikesUseCase: ReposLikesUseCaseProtocol {
    weak var output: ReposLikesUseCaseOutput!

    weak var reposGateway: ReposGatewayProtocol!
    weak var likesGateway: LikesGatewayProtocol!

    private var statusList = GitHubRepoStatusList(repos: [], likes: [:])

    // キーワードでリポジトリを検索し、結果とお気に入り状態を組み合わせた結果をOutputに通知する
    func startFetch(using keywords: [String]) {

        reposGateway.fetch(using: keywords) { [weak self] reposResult in
            guard let strongSelf = self else { return }

            switch reposResult {
            case .failure(let e):
                strongSelf.output
                    .useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
            case .success(let repos):
                let ids = repos.map { $0.id }
                strongSelf.likesGateway
                    .fetch(ids: ids) { [weak self] likesResult in
                        switch likesResult {
                        case .failure(let e):
                            strongSelf.output
                                .useCaseDidReceiveError(
                                    FetchingError.failedToFetchLikes(e))
                        case .success(let likes):
                            // 結果を保持
                            let statusList = GitHubRepoStatusList(
                                repos: repos,
                                likes: likes
                            )
                            self?.statusList = statusList
                            self?.output.useCaseDidUpdateStatuses(statusList.statuses)
                        }
                }
            }
        }
    }

    func requestLikedRepos() {
        //        <#code#>
    }

    func set(liked: Bool, for repo: GitHubRepo) {
        // お気に入りの状態を保存し、更新の結果を伝える
        likesGateway.save(liked: liked, for: repo.id)
        { [weak self] likesResult in
            guard let strongSelf = self else { return }

            switch likesResult {
            case .failure:
                strongSelf.output
                    .useCaseDidReceiveError(SavingError.failedToSaveLike)
            case .success(let isLiked):
                do {
                    try strongSelf.statusList.set(isLiked: isLiked,
                                                  for: repo.id)
                    strongSelf.output
                        .useCaseDidUpdateStatuses(statusList.statuses)
                } catch {
                    strongSelf.output
                        .useCaseDidReceiveError(SavingError.failedToSaveLike)
                }
            }
        }
    }
}
