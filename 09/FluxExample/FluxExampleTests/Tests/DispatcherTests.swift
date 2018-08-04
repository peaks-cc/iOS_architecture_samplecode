//
//  DispatcherTests.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/04.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import GitHub
@testable import FluxExample

final class DispatcherTests: XCTestCase {

    private var dispatcher: Dispatcher!

    override func setUp() {
        super.setUp()

        dispatcher = Dispatcher()
    }
    
    func testDispatchAction() {
        let users: [GitHub.User] = []
        let expect = expectation(description: "waiting Action.addUsers")

        let callback: (Action) -> () = { action in
            if case let .addUsers(_users) = action {
                XCTAssertEqual(_users.count, users.count)
                expect.fulfill()
            } else {
                XCTFail("It must be Action.addUser")
            }
        }

        let token = dispatcher.register(callback: callback)
        dispatcher.dispatch(.addUsers(users))

        wait(for: [expect], timeout: 0.1)

        dispatcher.unregister(token)
    }
    
    func testDispatchActions() {
        let users: [GitHub.User] = []
        let expect1 = expectation(description: "waiting Action.addUsers")
        let expect2 = expectation(description: "waiting Action.clearUsers")

        let callback: (Action) -> () = { action in
            switch action {
            case let .addUsers(_users):
                XCTAssertEqual(_users.count, users.count)
                expect1.fulfill()
            case .clearUsers:
                expect2.fulfill()
            default:
                XCTFail("Unexpected Action: \(action)")
            }
        }

        let token = dispatcher.register(callback: callback)
        dispatcher.dispatch(.addUsers(users))
        dispatcher.dispatch(.clearUsers)

        wait(for: [expect1, expect2], timeout: 0.1)

        dispatcher.unregister(token)
    }

    func testCallbacks() {
        let users: [GitHub.User] = []
        let expect1 = expectation(description: "waiting callback1")
        let expect2 = expectation(description: "waiting callback2")

        let callback1: (Action) -> () = { action in
            if case let .addUsers(_users) = action {
                XCTAssertEqual(_users.count, users.count)
                expect1.fulfill()
            } else {
                XCTFail("It must be Action.addUser")
            }
        }

        let callback2: (Action) -> () = { action in
            if case let .addUsers(_users) = action {
                XCTAssertEqual(_users.count, users.count)
                expect2.fulfill()
            } else {
                XCTFail("It must be Action.addUser")
            }
        }

        let token1 = dispatcher.register(callback: callback1)
        let token2 = dispatcher.register(callback: callback2)
        dispatcher.dispatch(.addUsers(users))

        wait(for: [expect1, expect2], timeout: 0.1)

        dispatcher.unregister(token1)
        dispatcher.unregister(token2)
    }
}
