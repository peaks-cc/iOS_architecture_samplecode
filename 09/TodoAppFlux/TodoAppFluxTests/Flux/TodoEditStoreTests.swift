//
//  TodoEditStoreTests.swift
//  TodoAppFluxTests
//
//  Created by marty-suzuki on 2018/07/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import Flux
@testable import TodoAppFlux

class TodoEditStoreTests: XCTestCase {
    var dispatcher: Dispatcher!
    var store: TodoEditStore!

    override func setUp() {
        super.setUp()

        self.dispatcher = Dispatcher()
        self.store = TodoEditStore(dispatcher: dispatcher)
    }

    func testStartEditingTodo() {
        let id = "id-1"
        let expect = expectation(description: "wait editStore changes")

        let subscription = store.addListener { [weak store] in
            XCTAssertEqual(store?.id, id)
            expect.fulfill()
        }

        dispatcher.dispatch(TodoAction.startEditingTodo(id: id))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertEqual(store.id, id)
    }

    func testStopEditingTodo() {
        let expect = expectation(description: "wait editStore changes")

        let subscription = store.addListener { [weak store] in
            XCTAssertNil(store?.id)
            expect.fulfill()
        }

        dispatcher.dispatch(TodoAction.stopEditingTodo)
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertNil(store.id)
    }
}
