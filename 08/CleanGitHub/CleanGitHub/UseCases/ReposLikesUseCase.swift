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
    func set(liked: Bool, for Repo: GitHubRepo)

    var output: ReposLikesUseCaseOutput? { get set }
}

protocol ReposLikesUseCaseOutput: AnyObject {
    // リポジトリとお気に入りとをペアにした情報が更新されたときに呼ばれる
    func useCaseDidUpdateStatuses(_ repoStatuses: [GitHubRepoStatus])
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

protocol ReposGatewayProtocol {
    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void)
}

protocol LikesGatewayProtocol {
    func fetch(ids: [GitHubRepo.ID], completion: (Result<[GitHubRepo.ID: Bool]>) -> Void)
    func save(liked: Bool, for id: GitHubRepo.ID, completion: (Result<Bool>) -> Void)
}

final class ReposLikesUseCase: ReposLikesUseCaseProtocol {
    weak var output: ReposLikesUseCaseOutput?

    private let reposGateway: ReposGatewayProtocol
    private let likesGateway: LikesGatewayProtocol

    private var statusList = GitHubRepoStatusList(repos: [], likes: [:])

    init(reposGateway: ReposGatewayProtocol,
         likesGateway: LikesGatewayProtocol) {

        self.reposGateway = reposGateway
        self.likesGateway = likesGateway
    }

    // キーワードでリポジトリを検索し、その結果とお気に入りの状態を組み合わせた結果を返す
    func startFetch(using keywords: [String]) {
        reposGateway.fetch(using: keywords) { [weak self] reposResult in
            switch reposResult {
            case .failure(let e):
                self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
            case .success(let repos):
                let ids = repos.map { $0.id }
                self?.likesGateway.fetch(ids: ids) { [weak self] likesResult in
                    switch likesResult {
                    case .failure(let e):
                        self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
                    case .success(let likes):
                        let statusList = GitHubRepoStatusList(
                            repos: repos,
                            likes: likes
                        )
                        self?.statusList = statusList
                        self?.output?.useCaseDidUpdateStatuses(statusList.statuses)
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
        likesGateway.save(liked: liked, for: repo.id) { [weak self] likesResult in
            guard let strongSelf = self else { return }
            switch likesResult {
            case .failure:
                self?.output?.useCaseDidReceiveError(SavingError.failedToSaveLike)
            case .success(let isLiked):
                do {
                    try strongSelf.statusList.set(isLiked: isLiked, for: repo.id)
                    self?.output?.useCaseDidUpdateStatuses(statusList.statuses)
                } catch {
                    self?.output?.useCaseDidReceiveError(SavingError.failedToSaveLike)
                }
            }
        }
    }
}
