//
//  GitHubRepositoryDispatcher.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/12.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class GitHubRepositoryDispatcher {
    static let shared = GitHubRepositoryDispatcher()

    let addRepositories = PublishRelay<[GitHub.Repository]>()
    let clearRepositories = PublishRelay<Void>()
    let pagination = PublishRelay<GitHub.Pagination?>()
    let selectedRepository = PublishRelay<GitHub.Repository?>()
    let isFetching = PublishRelay<Bool>()
    let favorites = PublishRelay<[GitHub.Repository]>()
    let error = PublishRelay<Error>()
}

