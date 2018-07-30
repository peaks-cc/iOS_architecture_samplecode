//
//  GithubAction.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/30.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

enum Action {

    // MARK: - Github.User

    case addUsers([Github.User])
    case clearUsers
    case userSelected(Github.User)
    case userUnselected
    case isSeachUsersFieldEditing(Bool)

    // MARK: -  Github.Repository

    case addRepositories([Github.Repository])
    case clearRepositories
    case repositorySelected(Github.Repository)
    case repositoryUnselected
}
