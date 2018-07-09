//
//  TodoStore.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Flux

final class TodoStore: Store<TodoAction> {
    static let shared = TodoStore()

    private(set) var todos: [Todo]
    private var lastID: Int

    override init(dispatcher: Dispatcher = .shared) {
        self.todos = []
        self.lastID = 1
        super.init(dispatcher: dispatcher)
    }

    override func onDispatch(_ action: TodoAction) {
        switch action {
        case let .addTodo(text):
            let id = "id-\(lastID)"
            lastID += 1
            let todo = Todo(id: id,
                            isCompleted: false,
                            text: text)
            todos.append(todo)

        case .deleteCompletedTodos:
            todos = todos.filter { !$0.isCompleted }

        case let .deleteTodo(id):
            todos = todos.filter { $0.id != id }

        case let .editTodo(id, text):
            guard let index = todos.index(where: { $0.id == id }) else {
                return
            }
            let todo = todos[index]
            todos[index] = Todo(id: todo.id,
                                isCompleted: todo.isCompleted,
                                text: text)

        case .toggleAllTodos:
            let isAllCompleted = todos.reduce(todos.count > 0) { $1.isCompleted && $0 }
            todos = todos.map {
                Todo(id: $0.id,
                     isCompleted: !isAllCompleted,
                     text: $0.text)
                }

        case let .toggleTodo(id):
            guard let index = todos.index(where: { $0.id == id }) else {
                return
            }
            let todo = todos[index]
            todos[index] = Todo(id: todo.id,
                                isCompleted: !todo.isCompleted,
                                text: todo.text)

        default:
            return
        }
        emitChange()
    }
}
