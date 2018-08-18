//
//  GitHubUserActionCreatorTests.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import XCTest
@testable import FluxPlusExample

final class GitHubUserActionCreatorTests: XCTestCase {

    private struct Dependency {

        let apiSession = MockGitHubApiSession()

        let actionCreator: GitHubUserActionCreator
        let dispatcher: GitHubUserDispatcher

        init() {
            let flux = Flux.mock(apiSession: apiSession)

            self.actionCreator = flux.userActionCreator
            self.dispatcher = flux.userDispatcher
        }
    }

    private func makeUser() -> GitHub.User {
        return GitHub.User(login: "username",
                           id: 1,
                           nodeID: "",
                           avatarURL: URL(string: "https://github.com/")!,
                           gravatarID: "",
                           url: URL(string: "https://github.com/")!,
                           receivedEventsURL: URL(string: "https://github.com/")!,
                           type: "")
    }

    private func makePagination() -> GitHub.Pagination {
        return GitHub.Pagination(next: nil, last: nil, first: nil, prev: nil)
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testSearchUsers() {
        let users = [makeUser()]
        let pagination = makePagination()

        let expect = expectation(description: "waiting dispatcher.addUsers")
        let disposable = dependency.dispatcher.addUsers
            .subscribe(onNext: { _users in
                XCTAssertEqual(_users.count, users.count)
                XCTAssertNotNil(_users.first)
                XCTAssertEqual(_users.first?.login, users.first?.login)
                expect.fulfill()
            })

        dependency.actionCreator.searchUsers(query: "username")
        dependency.apiSession.setSearchUsersResult(users: users, pagination: pagination)
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }

    func testClearUser() {
        let expect = expectation(description: "waiting dispatcher.clearUsers")
        let disposable = dependency.dispatcher.clearUsers
            .subscribe(onNext: {
                expect.fulfill()
            })

        dependency.actionCreator.clearUsers()
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }
}
