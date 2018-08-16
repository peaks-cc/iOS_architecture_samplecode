//
//  GitHubUserStoreTests.swift
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

final class GitHubUserStoreTests: XCTestCase {

    private struct Dependency {

        let store: GitHubUserStore
        let dispatcher: GitHubUserDispatcher

        init() {
            let flux = Flux.make()

            self.store = flux.userStore
            self.dispatcher = flux.userDispatcher
        }
    }

    private var dependency: Dependency!

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

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testAddUsers() {
        XCTAssertTrue(dependency.store.users.value.isEmpty)

        let users = [makeUser(), makeUser()]

        let expect = expectation(description: "waiting store changes")
        let disposable = dependency.store.users.changed
            .subscribe(onNext: { _users in
                XCTAssertEqual(_users.count, users.count)
                XCTAssertNotNil(_users.first)
                XCTAssertEqual(_users.first?.login, users.first?.login)
                expect.fulfill()
            })

        dependency.dispatcher.addUsers.accept(users)
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()

        XCTAssertEqual(dependency.store.users.value.count, users.count)
    }

    func testClearUsers() {
        let users = [makeUser(), makeUser()]

        dependency.dispatcher.addUsers.accept(users)
        XCTAssertFalse(dependency.store.users.value.isEmpty)

        let expect = expectation(description: "waiting store changes")
        let disposable = dependency.store.users.changed
            .subscribe(onNext: { users in
                XCTAssertTrue(users.isEmpty)
                expect.fulfill()
            })

        dependency.dispatcher.clearUsers.accept(())
        wait(for: [expect], timeout: 0.1)
        disposable.dispose()

        XCTAssertTrue(dependency.store.users.value.isEmpty)
    }
}
