//
//  GitHubUserStoreTests.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/05.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxExample

final class GitHubUserStoreTests: XCTestCase {

    private struct Dependency {
        let dispatcher = Dispatcher()
        let store: GitHubUserStore

        init() {
            self.store = GitHubUserStore(dispatcher: dispatcher)
        }
    }

    private var dependency: Dependency!

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

    override func setUp() {
        super.setUp()

        dependency = Dependency()
    }

    func testAddUsers() {
        XCTAssertTrue(dependency.store.users.isEmpty)

        let users = [makeUser(), makeUser()]
        dependency.dispatcher.dispatch(.addUsers(users))

        XCTAssertEqual(dependency.store.users.count, users.count)
    }

    func testClearUsers() {
        let users = [makeUser(), makeUser()]
        dependency.dispatcher.dispatch(.addUsers(users))
        XCTAssertFalse(dependency.store.users.isEmpty)

        dependency.dispatcher.dispatch(.clearUsers)

        XCTAssertTrue(dependency.store.users.isEmpty)
    }
}
