//
//  ReposPresenter.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

protocol ReposPresenterInput {
    // キーワードを使ったサーチ
    func startFetch(using keywords: [String])
    // お気に入り済みリポジトリ一覧の取得
    func requestLikedRepos()

    // お気に入りの追加・削除
}

protocol ReposPresenterOutput {
    // 表示用のモデルが変化したことを通知
    func didUpdate(_ viewModels: [RepoStatus])
}

class ReposPresenter: ReposLikesUseCaseOutput, ReposPresenterInput {

    let usecaseInput: ReposLikesUseCaseInput
    var presenterOutput: ReposPresenterOutput?

    init(usecaseInput: ReposLikesUseCaseInput,
         presenterOutput: ReposPresenterOutput?) {

        self.usecaseInput = usecaseInput
        self.presenterOutput = presenterOutput
    }

    func startFetch(using keywords: [String]) {
        // Use Caseに検索を依頼
        usecaseInput.startFetch(using: keywords)
    }

    func requestLikedRepos() {
        usecaseInput.requestLikedRepos()
    }
    
    func useCaseDidReceive(_ repoStatus: [RepoStatus]) {
        // 届いたペアを出力ポートへ流す
        presenterOutput?.didUpdate(repoStatus)
    }
    
    func useCaseDidUpdate(_ likes: [Like]) {
//        <#code#>
    }

    func useCaseDidReceiveError(_ error: Error) {
//        <#code#>
    }
    
}
