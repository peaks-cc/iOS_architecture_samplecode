//
//  Action.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/10/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

enum Action {

    // MARK: -  Search

    case searchQuery(String?)
    case searchPagination(GitHub.Pagination?)
    case searchRepositories([GitHub.Repository])
    case clearSearchRepositories
    case isRepositoriesFetching(Bool)
    case isSearchFieldEditing(Bool)
    case error(Error)

    // MARK: - Favorite

    case setFavoriteRepositories([GitHub.Repository])

    // MARK: - Others

    case selectedRepository(GitHub.Repository?)
}
