//
//  ActionCreatorTests.swift
//  FluxWithRxSwiftTests
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import XCTest
@testable import FluxWithRxSwift

final class ActionCreatorTests: XCTestCase {

    private struct Dependency {

        let apiSession = MockGitHubApiSession()

        let actionCreator: ActionCreator
        let dispatcher = Dispatcher()

        init() {
            self.actionCreator = ActionCreator(dispatcher: dispatcher,
                                               apiSession: apiSession,
                                               localCache: MockLocalCache())
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testSearchRepositories() {
        let repositories: [GitHub.Repository] = [.mock()]
        let pagination = GitHub.Pagination.mock()

        var count: Int = 0
        let expect = expectation(description: "waiting dispatcher.addRepositories")
        let disposable = dependency.dispatcher.register(callback: { action in
            count += 1

            guard count == 3 else {
                return
            }

            guard case let .searchRepositories(_repositories) = action else {
                XCTFail("action must be .searchRepositories, but it is \(action)")
                return
            }

            XCTAssertEqual(_repositories.count, repositories.count)
            XCTAssertNotNil(_repositories.first)
            XCTAssertEqual(_repositories.first?.fullName, repositories.first?.fullName)
            expect.fulfill()
        })

        dependency.actionCreator.searchRepositories(query: "repository-name")
        dependency.apiSession.setSearchRepositoriesResult(repositories: repositories, pagination: pagination)
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }

    func testClearUser() {
        let expect = expectation(description: "waiting dispatcher.clearRepositories")
        let disposable = dependency.dispatcher.register(callback: { action in
            guard case .clearSearchRepositories = action else {
                XCTFail("action must be .clearSearchRepositories, but it is \(action)")
                return
            }

            expect.fulfill()
        })

        dependency.actionCreator.clearRepositories()
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }
}
