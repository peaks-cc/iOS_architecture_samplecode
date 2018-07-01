//
//  TodoDraftStoreTests.swift
//  TodoAppFluxTests
//
//  Created by marty-suzuki on 2018/07/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import Flux
@testable import TodoAppFlux

class TodoDraftStoreTests: XCTestCase {
    var dispatcher: Dispatcher!
    var store: TodoDraftStore!

    override func setUp() {
        super.setUp()

        self.dispatcher = Dispatcher()
        self.store = TodoDraftStore(dispatcher: dispatcher)
    }

    func testAddTodo() {
        let expect = expectation(description: "wait draftStore changes")

        let subscription = store.addListener { [weak store] in
            XCTAssertNil(store?.text)
            expect.fulfill()
        }

        dispatcher.dispatch(TodoAction.addTodo(text: "hoge"))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertNil(store.text)
    }

    func testStopEditingTodo() {
        let expect = expectation(description: "wait draftStore changes")

        let subscription = store.addListener { [weak store] in
            XCTAssertNil(store?.text)
            expect.fulfill()
        }

        dispatcher.dispatch(TodoAction.stopEditingTodo)
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertNil(store.text)
    }

    func testUpdateDraft() {
        let text = "Great Scott!!"
        let expect = expectation(description: "wait draftStore changes")

        let subscription = store.addListener { [weak store] in
            XCTAssertEqual(store?.text, text)
            expect.fulfill()
        }

        dispatcher.dispatch(TodoAction.updateDraft(text: text))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertEqual(store.text, text)
    }
}
