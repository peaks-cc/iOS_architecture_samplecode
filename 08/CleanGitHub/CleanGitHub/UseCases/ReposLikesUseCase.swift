//
//  ReposLikesUseCase.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol ReposLikesUseCaseInput {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func requestLikedRepos()
    // お気に入りの追加・削除
    func set(liked: Bool, for Repo: GitHubRepo)
}

protocol ReposLikesUseCaseOutput {
    // リポジトリとお気に入りとをペアにした情報が更新されたときに呼ばれる
    func useCaseDidReceive(_ repoStatus: [RepoStatus])
    // お気に入りの一覧情報が更新されたときに呼ばれる
    func useCaseDidUpdate(_ likes: [Like])
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}

protocol ReposProtocol {
    func fetch(using keywords: [String], completion: (Result<[GitHubRepo]>) -> Void)
    func fetch(using likes: [Like], completion: (Result<[GitHubRepo]>) -> Void)
}

protocol LikesProtocol {
    func fetch(byNames names: [String], completion: (Result<[Like]>) -> Void)
    func save(liked: Bool, for repo: GitHubRepo, completion: (Result<Like>) -> Void)
}

class ReposLikesUseCase: ReposLikesUseCaseInput {

    var output: ReposLikesUseCaseOutput?

    var reposGateway: ReposProtocol?
    var likesGateway: LikesProtocol?

    init(output: ReposLikesUseCaseOutput?,
         reposGateway: ReposProtocol?,
         likesGateway: LikesProtocol?) {

        self.output = output
        self.reposGateway = reposGateway
        self.likesGateway = likesGateway
    }

    // キーワードでリポジトリを検索し、その結果とお気に入りの状態を組み合わせた結果を返す
    func startFetch(using keywords: [String]) {
        reposGateway?.fetch(using: keywords) { [weak self] reposResult in
            switch reposResult {
            case .failure(let e):
                self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
            case .success(let repos):
                var repoStatusList = RepoStatusList()
                repoStatusList.register(repos: repos)

                self?.likesGateway?.fetch(byNames: []) { [weak self] likesResult in
                    switch likesResult {
                    case .failure(let e):
                        self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
                    case .success(let likes):
                        repoStatusList.register(likes: likes)
                        self?.output?.useCaseDidReceive(repoStatusList.allStatus)
                    }
                }
            }
        }
    }
    
    func requestLikedRepos() {
        // お気に入りの一覧を取得し、対象のリポジトリ情報と組み合わせた結果を返す
        likesGateway?.fetch(byNames: []) { [weak self] likesResult in
            switch likesResult {
            case .failure(let e):
                self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchLikes(e))
            case .success(let likes):
                self?.reposGateway?.fetch(using: likes) { repoResult in
                    switch repoResult {
                    case .failure(let e):
                        self?.output?.useCaseDidReceiveError(FetchingError.failedToFetchRepos(e))
                    case .success(let repos):
                        let reposAndLikes: [(GitHubRepo, Like?)] = repos.map { repo in
                            (repo,
                             likes.first(where: { $0.id == repo.id })
                            )
                        }
                        self?.output?.useCaseDidReceive(reposAndLikes)
                    }
                }
            }
        }
    }

    func set(liked: Bool, for repo: GitHubRepo) {
        // お気に入りの状態を保存し、更新の結果を伝える
        likesGateway?.save(liked: liked, for: repo) { [weak self] likesResult in
            switch likesResult {
            case .failure(let e):
                self?.output?.useCaseDidReceiveError(SavingError.failedToSaveLike(e))
            case .success(let like):
                self?.output?.useCaseDidUpdate([like])
            }
        }
    }
}
