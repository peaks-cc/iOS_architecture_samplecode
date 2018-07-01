//
//  TodoActionCreatorTests.swift
//  TodoAppFluxTests
//
//  Created by marty-suzuki on 2018/07/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import Flux
@testable import TodoAppFlux

class TodoActionCreatorTests: XCTestCase {
    var dispatcher: Dispatcher!
    var actionCreator: TodoActionCreator!

    override func setUp() {
        super.setUp()

        self.dispatcher = Dispatcher()
        self.actionCreator = TodoActionCreator(dispatcher: dispatcher)
    }

    func testUpdateDraft() {
        let text = "Great Scott!!"
        let expect = expectation(description: "wait updateDraft")
        let token = dispatcher.register(callback: { action in
            if case let .updateDraft(t)? = action as? TodoAction {
                XCTAssertEqual(t, text)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.updateDraft(text: text)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testAddTodo() {
        let text = "Great Scott!!"
        let expect = expectation(description: "wait addTodo")
        let token = dispatcher.register(callback: { action in
            if case let .addTodo(t)? = action as? TodoAction {
                XCTAssertEqual(t, text)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.addTodo(text: text)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testEditTodo() {
        let todo = Todo(id: "id-1", isCompleted: false, text: "Heavy")
        let text = "Great Scott!!"
        let expect = expectation(description: "wait editTodo")
        let token = dispatcher.register(callback: { action in
            if case let .editTodo(id, t)? = action as? TodoAction {
                XCTAssertEqual(t, text)
                XCTAssertEqual(id, todo.id)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.editTodo(id: todo.id, text: text)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testStartEditingTodo() {
        let todo = Todo(id: "id-1", isCompleted: false, text: "Heavy")
        let expect = expectation(description: "wait startEditingTodo")
        let token = dispatcher.register(callback: { action in
            if case let .startEditingTodo(id)? = action as? TodoAction {
                XCTAssertEqual(id, todo.id)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.startEditingTodo(id: todo.id)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testStopEditingTodo() {
        let expect = expectation(description: "wait stopEditingTodo")
        let token = dispatcher.register(callback: { action in
            if case .stopEditingTodo? = action as? TodoAction {
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.stopEditingTodo()
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testDeleteTodo() {
        let todo = Todo(id: "id-1", isCompleted: false, text: "Heavy")
        let expect = expectation(description: "wait deleteTodo")
        let token = dispatcher.register(callback: { action in
            if case let .deleteTodo(id)? = action as? TodoAction {
                XCTAssertEqual(id, todo.id)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.deleteTodo(id: todo.id)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testDeleteCompletedTodos() {
        let expect = expectation(description: "wait deleteCompletedTodos")
        let token = dispatcher.register(callback: { action in
            if case .deleteCompletedTodos? = action as? TodoAction {
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.deleteCompletedTodos()
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testToggleTodo() {
        let todo = Todo(id: "id-1", isCompleted: false, text: "Heavy")
        let expect = expectation(description: "wait toggleTodo")
        let token = dispatcher.register(callback: { action in
            if case let .toggleTodo(id)? = action as? TodoAction {
                XCTAssertEqual(id, todo.id)
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.toggleTodo(id: todo.id)
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }

    func testToggleAllTodos() {
        let expect = expectation(description: "wait toggleAllTodos")
        let token = dispatcher.register(callback: { action in
            if case .toggleAllTodos? = action as? TodoAction {
                expect.fulfill()
            } else {
                XCTFail()
            }
        })
        actionCreator.toggleAllTodos()
        wait(for: [expect], timeout: 0.1)
        dispatcher.unregister(token: token)
    }
}
