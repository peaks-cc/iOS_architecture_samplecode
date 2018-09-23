//
//  AppDelegate.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/23.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

// MEMO

// - View
//   - UserCell
//     - UserView
//   - UserSearchBar
//   - UserView
//     - icon
//     - id
//   - RepositoryCell
//     - userName
//     - name
//     - description

// - SearchUserViewController
//   - View
//     - UserCell
//     - UserSearchBar
//   - Feature
//     - searchUser
//     - transitionToUserDetail
// - UserDetailViewController
//   - View
//     - UserView
//     - RepositoryCell
//   - Feature
//     - transitionToWeb
//     - transitionToRepositoryDetail
// - RepositoryDetailViewController
//   - View
//     - UserView
//     - SeeAlso(Repositories)
//       - RepositoryCell
//   - Feature
//     - transitionToWeb
//     - transitionToUserDetail
//     - transitionToRepositoryDetail

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

