//
//  RepoStatusListTest.swift
//  CleanGitHubTests
//
//  Created by 加藤寛人 on 2018/09/23.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import XCTest

class RepoStatusListTest: XCTestCase {

    private func makeGitHubRepo(id: String="", fullName: String="",
                                description: String="", language: String="",
                                stargazersCount: Int=0) -> GitHubRepo {
        return GitHubRepo(id: id, fullName: fullName,
                          description: description, language: language,
                          stargazersCount: stargazersCount)
    }
    private func makeLike(id: String="", isLiked: Bool=false) -> Like {
        return Like(id: id, isLiked: isLiked)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegisterRepos() {
        var list = RepoStatusList()

        XCTAssert(list.allStatus.count == 0)

        list.register(repos: [makeGitHubRepo(),makeGitHubRepo()])
        list.register(likes: [makeLike(),makeLike()])
        XCTAssert(list.allStatus.count == 2)

        list.register(repos: [makeGitHubRepo()])
        list.register(likes: [makeLike(),makeLike()])
        XCTAssert(list.allStatus.count == 1)

        list.register(repos: [makeGitHubRepo(),makeGitHubRepo()])
        list.register(likes: [makeLike()])
        XCTAssert(list.allStatus.count == 2)
    }

    func testLikeRepo() {
        var list = RepoStatusList()

        list.register(repos: [makeGitHubRepo(id: "1")])
        XCTAssertNoThrow(try list.likeRepo(of: "1"))
        XCTAssert(try list.status(of: "1").repo.id == "1")
        XCTAssertNotNil(try list.status(of: "1").like)
        XCTAssert(try list.status(of: "1").like!.isLiked == true)
        XCTAssertThrowsError(try list.likeRepo(of: "2"))

        list.register(repos: [makeGitHubRepo(id: "1")])
        list.register(likes: [makeLike(id: "1", isLiked: true)])
        XCTAssertNoThrow(try list.likeRepo(of: "1"))
        XCTAssert(try list.status(of: "1").repo.id == "1")
        XCTAssertNotNil(try list.status(of: "1").like)
        XCTAssert(try list.status(of: "1").like!.id == "1")
        XCTAssert(try list.status(of: "1").like!.isLiked == true)
    }
}
