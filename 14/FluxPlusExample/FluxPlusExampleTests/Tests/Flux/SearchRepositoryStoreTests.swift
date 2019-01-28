//
//  SearchRepositoryStoreTests.swift
//  FluxPlusExampleTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
import XCTest
@testable import FluxPlusExample

final class SearchRepositoryStoreTests: XCTestCase {

    private struct Dependency {

        let store: SearchRepositoryStore
        let dispatcher: SearchRepositoryDispatcher

        init() {
            let flux = Flux.mock()

            self.store = flux.searchRepositoryStore
            self.dispatcher = flux.searchRepositoryDispatcher
        }
    }

    private var dependency: Dependency!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testAddRepositories() {
        XCTAssertTrue(dependency.store.repositories.value.isEmpty)

        let repositories: [GitHub.Repository] = [.mock(), .mock()]

        let expect = expectation(description: "waiting store changes")
        let disposable = dependency.store.repositories.changed
            .subscribe(onNext: { _repositories in
                XCTAssertEqual(_repositories.count, repositories.count)
                XCTAssertNotNil(_repositories.first)
                XCTAssertEqual(_repositories.first?.fullName, repositories.first?.fullName)
                expect.fulfill()
            })

        dependency.dispatcher.addRepositories.accept(repositories)
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()

        XCTAssertEqual(dependency.store.repositories.value.count, repositories.count)
    }

    func testClearRepositories() {
        let repositories: [GitHub.Repository] = [.mock(), .mock()]

        dependency.dispatcher.addRepositories.accept(repositories)
        XCTAssertFalse(dependency.store.repositories.value.isEmpty)

        let expect = expectation(description: "waiting store changes")
        let disposable = dependency.store.repositories.changed
            .subscribe(onNext: { repositories in
                XCTAssertTrue(repositories.isEmpty)
                expect.fulfill()
            })

        dependency.dispatcher.clearRepositories.accept(())
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()

        XCTAssertTrue(dependency.store.repositories.value.isEmpty)
    }
}
