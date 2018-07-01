//
//  TodoAction.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Flux

enum TodoAction: Action {
    case addTodo(text: String)
    case deleteCompletedTodos
    case deleteTodo(id: Todo.ID)
    case editTodo(id: Todo.ID, text: String)
    case startEditingTodo(id: Todo.ID)
    case stopEditingTodo
    case toggleAllTodos
    case toggleTodo(id: Todo.ID)
    case updateDraft(text: String)
}
