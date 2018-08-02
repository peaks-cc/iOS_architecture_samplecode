//
//  GithubAction.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/30.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

enum Action {

    // MARK: - Github.User

    case addUsers([GitHub.User])
    case clearUsers
    case searchUsersPagination(GitHub.Pagination)
    case clearSearchUsersPagination
    case searchQuery(String)
    case clearSearchQuery
    case userSelected(GitHub.User)
    case userUnselected
    case isSeachUsersFieldEditing(Bool)
    case isSearchUsersFetching(Bool)

    // MARK: -  Github.Repository

    case addRepositories([GitHub.Repository])
    case clearRepositories
    case repositoriesPagination(GitHub.Pagination)
    case clearRepositoriesPagination
    case repositorySelected(GitHub.Repository)
    case repositoryUnselected
    case loadFavoriteRepositories([GitHub.Repository])

    // MARK: - Others

    case error(Error)
    case clearError
}
