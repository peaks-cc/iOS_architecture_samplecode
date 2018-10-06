//
//  ReposPresenter.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

struct GitHubRepoViewData {
    let id: String
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int
    let isLiked: Bool
}

protocol ReposPresenterProtocol {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func requestLikedRepos()

    // お気に入りの追加・削除


    var output: ReposPresenterOutput? { get set }
}

protocol ReposPresenterOutput: AnyObject {
    func update(by viewDataArray: [GitHubRepoViewData])
}

class ReposPresenter: ReposPresenterProtocol, ReposLikesUseCaseOutput {

    private var useCase: ReposLikesUseCaseProtocol
    weak var output: ReposPresenterOutput?

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
    
    func useCaseDidUpdateStatuses(_ repoStatus: [GitHubRepoStatus]) {
        // 届いたペアをView用のモデルに変換
//        <#code#>
    }
    
//    func useCaseDidUpdate(_ likes: [Like]) {
////        <#code#>
//    }

    func useCaseDidReceiveError(_ error: Error) {
//        <#code#>
    }
    
}
