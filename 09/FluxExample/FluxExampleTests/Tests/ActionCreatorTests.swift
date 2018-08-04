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

    func makeUser() -> GitHub.User {
        return GitHub.User(login: "username",
                           id: 1,
                           nodeID: "",
                           avatarURL: URL(string: "https://github.com/")!,
                           gravatarID: "",
                           url: URL(string: "https://github.com/")!,
                           receivedEventsURL: URL(string: "https://github.com/")!,
                           type: "")
    }

    func makePagination() -> GitHub.Pagination {
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
        let expect = expectation(description: "waiting Action.addUsers")

        dependency.apiSession.searchUsersResult = .success((users, pagination))

        let callback: (Action) -> () = { action in
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
                XCTFail("It must be Action.addUsers")
            }
        }

        let token = dependency.dispatcher.register(callback: callback)
        dependency.actionCreator.searchUsers(query: "username")

        wait(for: [expect], timeout: 0.1)

        dependency.dispatcher.unregister(token)
    }
    
    func testClearUser() {
        let expect = expectation(description: "waiting Action.clearUsers")

        let callback: (Action) -> () = { action in
            if case .clearUsers = action {
                expect.fulfill()
            } else {
                XCTFail("It must be Action.clearUsers")
            }
        }

        let token = dependency.dispatcher.register(callback: callback)
        dependency.actionCreator.clearUsers()

        wait(for: [expect], timeout: 0.1)

        dependency.dispatcher.unregister(token)
    }
}
