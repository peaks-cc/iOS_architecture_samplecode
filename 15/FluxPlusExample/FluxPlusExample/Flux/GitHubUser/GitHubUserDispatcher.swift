//
//  GitHubUserDispatcher.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/10.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class GitHubUserDispatcher {
    static let shared = GitHubUserDispatcher()

    let addUsers = PublishRelay<[GitHub.User]>()
    let clearUsers = PublishRelay<Void>()
    let pagination = PublishRelay<GitHub.Pagination?>()
    let searchQuery = PublishRelay<String?>()
    let selectedUser = PublishRelay<GitHub.User?>()
    let isFieldEditing = PublishRelay<Bool>()
    let isFetching = PublishRelay<Bool>()
    let error = PublishRelay<Error>()
}
