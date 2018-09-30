//
//  SearchRepositoryActionCreator.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class SearchRepositoryActionCreator {

    static let shared = SearchRepositoryActionCreator()

    private let dispatcher: SearchRepositoryDispatcher
    private let apiSession: GitHubApiRequestable

    init(dispatcher: SearchRepositoryDispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared) {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
    }

    func searchRepositories(query: String, page: Int = 1) {
        dispatcher.query.accept(query)
        dispatcher.isFetching.accept(true)
        apiSession.searchRepositories(query: query, page: page) { [dispatcher] result in
            switch result {
            case let .success(repositories, pagination):
                dispatcher.addRepositories.accept(repositories)
                dispatcher.pagination.accept(pagination)
            case let .failure(error):
                dispatcher.error.accept(error)
            }
            dispatcher.isFetching.accept(false)
        }
    }

    func setIsSearchFieldEditing(_ isEditing: Bool) {
        dispatcher.isSearchFieldEditing.accept(isEditing)
    }

    func clearRepositories() {
        dispatcher.clearRepositories.accept(())
    }
}
