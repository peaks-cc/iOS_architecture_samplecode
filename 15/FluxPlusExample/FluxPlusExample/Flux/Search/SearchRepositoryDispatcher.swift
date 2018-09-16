//
//  SearchRepositoryDispatcher.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SearchRepositoryDispatcher {
    static let shared = SearchRepositoryDispatcher()

    let query = PublishRelay<String?>()
    let addRepositories = PublishRelay<[GitHub.Repository]>()
    let clearRepositories = PublishRelay<Void>()
    let pagination = PublishRelay<GitHub.Pagination?>()
    let isFetching = PublishRelay<Bool>()
    let isSearchFieldEditing = PublishRelay<Bool>()
    let error = PublishRelay<Error>()
}
