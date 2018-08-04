//
//  ActionCreatorTests.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/04.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxExample

final class ActionCreatorTests: XCTestCase {
    
    private struct Dependency {
        let actionCreator: ActionCreator

        let dispatcher = Dispatcher()
        let apiSession = MockGitHubApiSession()
        let localCache = MockLocalCache()

        init() {
            self.actionCreator = ActionCreator(dispatcher: dispatcher,
                                               apiSession: apiSession,
                                               localCache: localCache)
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
        dependency.apiSession.searchUsersResult = .success((users, pagination))

        let expect = expectation(description: "waiting Action.addUsers")
        _ = dependency.dispatcher.register { action in
            switch action {
            case let .addUsers(_users):
                XCTAssertEqual(_users.count, users.count)
                XCTAssertNotNil(_users.first)
                XCTAssertEqual(_users.first?.login, users.first?.login)
                expect.fulfill()
            case .searchQuery,
                 .isSearchUsersFetching,
                 .searchUsersPagination:
                return
            default:
                XCTFail("Unexpected Action: \(action)")
            }
        }
        
        dependency.actionCreator.searchUsers(query: "username")
        wait(for: [expect], timeout: 0.1)
    }
    
    func testClearUser() {
        let expect = expectation(description: "waiting Action.clearUsers")
        _ = dependency.dispatcher.register { action in
            if case .clearUsers = action {
                expect.fulfill()
            } else {
                XCTFail("It must be Action.clearUsers")
            }
        }

        dependency.actionCreator.clearUsers()
        wait(for: [expect], timeout: 0.1)
    }
}
