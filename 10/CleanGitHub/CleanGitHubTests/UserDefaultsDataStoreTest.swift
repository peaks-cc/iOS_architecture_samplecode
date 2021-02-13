//
//  UserDefaultsDataStoreTest.swift
//  CleanGitHubTests
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import XCTest
@testable import CleanGitHub

class UserDefaultsDataStoreTest: XCTestCase {

    var dataStore: UserDefaultsDataStore!

    override func setUp() {
        dataStore = UserDefaultsDataStore(userDefaults: UserDefaults.standard)
    }

    func testSaveLike() {
        let repo: GitHubRepo = .init(id: GitHubRepo.ID(rawValue: "foobar"),
                                     fullName: "barbaz",
                                     description: "desc",
                                     language: "Swift",
                                     stargazersCount: 0)
        dataStore.save(liked: true, for: repo.id) { result in
            if case .success(let isLiked) = result {
                XCTAssertTrue(isLiked)
            } else {
                XCTFail("result must be a success.")
            }
        }
    }

    func testSaveGitHubRepo() {
        let repo: GitHubRepo = .init(id: GitHubRepo.ID(rawValue: "foobar"),
                                     fullName: "barbaz",
                                     description: "desc",
                                     language: "Swift",
                                     stargazersCount: 0)
        dataStore.save(repos: [repo]) { result in
            if case .success(let repo) = result {
                XCTAssertEqual(repo.map(\.fullName), ["barbaz"])
            } else {
                XCTFail("result must be a success.")
            }
        }
    }
}
