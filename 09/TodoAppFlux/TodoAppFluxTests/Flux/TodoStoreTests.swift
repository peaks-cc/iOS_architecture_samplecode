//
//  TodoStoreTests.swift
//  TodoAppFluxTests
//
//  Created by marty-suzuki on 2018/07/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import Flux
@testable import TodoAppFlux

class TodoStoreTests: XCTestCase {
    var dispatcher: Dispatcher!
    var store: TodoStore!
    
    override func setUp() {
        super.setUp()

        self.dispatcher = Dispatcher()
        self.store = TodoStore(dispatcher: dispatcher)
    }
    

    func testAddTodo() {
        let textList = ["Go to 1955", "Back to 1985", "Got to 2015"]
        let ids = ["id-1", "id-2", "id-3"]
        let assert: (TodoStore) -> () = { store in
            XCTAssertEqual(store.todos.count, textList.count)
            XCTAssertEqual(store.todos.map { $0.id }, ids)
            XCTAssertEqual(store.todos.map { $0.text }, textList)
            XCTAssertNil(store.todos.first { $0.isCompleted })
        }

        let expect = expectation(description: "wait todoStore changes")
        var count: Int = 0
        let subscription = store.addListener { [weak store] in
            count += 1
            if count == textList.count, let store = store {
                assert(store)
                expect.fulfill()
            }
        }

        textList.forEach {
            dispatcher.dispatch(TodoAction.addTodo(text: $0))
        }
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        assert(store)
    }

    func testDeleteTodo() {
        let textList = ["Go to 1955", "Back to 1985", "Got to 2015"]
        textList.forEach {
            dispatcher.dispatch(TodoAction.addTodo(text: $0))
        }
        guard let firstTodo = store.todos.first else {
            XCTFail()
            return
        }
        let assert: (TodoStore) -> () = { store in
            XCTAssertEqual(store.todos.count, 2)
            XCTAssertEqual(store.todos.map { $0.text }, textList.filter { $0 != firstTodo.text })
            XCTAssertNil(store.todos.first { $0.isCompleted })
        }

        let expect = expectation(description: "wait todoStore changes")
        let subscription = store.addListener { [weak store] in
            if let store = store {
                assert(store)
                expect.fulfill()
            } else {
                XCTFail()
            }
        }

        dispatcher.dispatch(TodoAction.deleteTodo(id: firstTodo.id))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        assert(store)
    }

    func testToggleTodo() {
        let textList = ["Go to 1955", "Back to 1985", "Got to 2015"]
        textList.forEach {
            dispatcher.dispatch(TodoAction.addTodo(text: $0))
        }
        guard let lastTodo = store.todos.last else {
            XCTFail()
            return
        }
        let assert: (TodoStore) -> () = { store in
            XCTAssertEqual(store.todos.count, 3)
            XCTAssertEqual(store.todos.first { $0.isCompleted }?.id, lastTodo.id)
        }

        let expect = expectation(description: "wait todoStore changes")
        let subscription = store.addListener { [weak store] in
            if let store = store {
                assert(store)
                expect.fulfill()
            } else {
                XCTFail()
            }
        }

        dispatcher.dispatch(TodoAction.toggleTodo(id: lastTodo.id))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        assert(store)
    }

    func testToggleAllTodos() {
        let textList = ["Go to 1955", "Back to 1985", "Got to 2015"]
        textList.forEach {
            dispatcher.dispatch(TodoAction.addTodo(text: $0))
            guard let id = store.todos.last?.id else {
                XCTFail()
                return
            }
            dispatcher.dispatch(TodoAction.toggleTodo(id: id))
        }

        let assert: (TodoStore) -> () = { store in
            XCTAssertEqual(store.todos.count, 3)
            XCTAssertEqual(store.todos.filter { $0.isCompleted }.count, 0)
        }

        let expect = expectation(description: "wait todoStore changes")
        let subscription = store.addListener { [weak store] in
            if let store = store {
                assert(store)
                expect.fulfill()
            } else {
                XCTFail()
            }
        }

        dispatcher.dispatch(TodoAction.toggleAllTodos)
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        assert(store)
    }

    func testEditTodo() {
        let beforeText = "Go to 1955"
        let afterText = "Back to 1985"
        dispatcher.dispatch(TodoAction.addTodo(text: beforeText))
        guard let todo = store.todos.last else {
            XCTFail()
            return
        }

        let expect = expectation(description: "wait todoStore changes")
        let subscription = store.addListener { [weak store] in
            if let editedTodo = store?.todos.first(where: { $0.id == todo.id }) {
                XCTAssertEqual(editedTodo.text, afterText)
                expect.fulfill()
            } else {
                XCTFail()
            }
        }

        dispatcher.dispatch(TodoAction.editTodo(id: todo.id, text: afterText))
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        if let editedTodo = store.todos.first(where: { $0.id == todo.id }) {
            XCTAssertEqual(editedTodo.text, afterText)
        } else {
            XCTFail()
        }
    }

    func testDeleteCompletedTodos() {
        let textList = ["Go to 1955", "Back to 1985", "Got to 2015"]
        textList.forEach {
            dispatcher.dispatch(TodoAction.addTodo(text: $0))
            guard let id = store.todos.last?.id else {
                XCTFail()
                return
            }
            dispatcher.dispatch(TodoAction.toggleTodo(id: id))
        }

        let expect = expectation(description: "wait todoStore changes")
        let subscription = store.addListener { [weak store] in
            if let store = store {
                XCTAssertEqual(store.todos.count, 0)
                expect.fulfill()
            } else {
                XCTFail()
            }
        }

        dispatcher.dispatch(TodoAction.deleteCompletedTodos)
        wait(for: [expect], timeout: 0.1)
        store.removeListener(subscription)

        XCTAssertEqual(store.todos.count, 0)
    }
}
