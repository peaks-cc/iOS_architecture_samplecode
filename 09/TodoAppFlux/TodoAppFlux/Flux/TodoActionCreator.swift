//
//  TodoActionCreator.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Flux

final class TodoActionCreator {
    static let shared = TodoActionCreator(dispatcher: .shared)

    private let dispatcher: Dispatcher

    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }

    func updateDraft(text: String) {
        dispatcher.dispatch(TodoAction.updateDraft(text: text))
    }

    func addTodo(text: String) {
        dispatcher.dispatch(TodoAction.addTodo(text: text))
    }

    func editTodo(id: Todo.ID, text: String) {
        dispatcher.dispatch(TodoAction.editTodo(id: id, text: text))
    }

    func startEditingTodo(id: Todo.ID) {
        dispatcher.dispatch(TodoAction.startEditingTodo(id: id))
    }

    func stopEditingTodo() {
        dispatcher.dispatch(TodoAction.stopEditingTodo)
    }

    func deleteTodo(id: Todo.ID) {
        dispatcher.dispatch(TodoAction.deleteTodo(id: id))
    }

    func deleteCompletedTodos() {
        dispatcher.dispatch(TodoAction.deleteCompletedTodos)
    }

    func toggleTodo(id: Todo.ID) {
        dispatcher.dispatch(TodoAction.toggleTodo(id: id))
    }

    func toggleAllTodos() {
        dispatcher.dispatch(TodoAction.toggleAllTodos)
    }
}
