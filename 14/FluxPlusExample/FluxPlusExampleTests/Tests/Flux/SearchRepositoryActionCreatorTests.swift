//
//  SearchRepositoryActionCreatorTests.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import XCTest
@testable import FluxPlusExample

final class SearchRepositoryActionCreatorTests: XCTestCase {

    private struct Dependency {

        let apiSession = MockGitHubApiSession()

        let actionCreator: SearchRepositoryActionCreator
        let dispatcher: SearchRepositoryDispatcher

        init() {
            let flux = Flux.mock(apiSession: apiSession)

            self.actionCreator = flux.searchRepositoryActionCreator
            self.dispatcher = flux.searchRepositoryDispatcher
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

        let expect = expectation(description: "waiting dispatcher.addRepositories")
        let disposable = dependency.dispatcher.addRepositories
            .subscribe(onNext: { _repositories in
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
        let disposable = dependency.dispatcher.clearRepositories
            .subscribe(onNext: {
                expect.fulfill()
            })

        dependency.actionCreator.clearRepositories()
        wait(for: [expect], timeout: 0.1)

        disposable.dispose()
    }
}
