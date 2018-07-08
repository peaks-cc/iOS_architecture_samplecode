//
//  TodoEditStore.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Flux

final class TodoEditStore: Store<TodoAction> {
    static let shared = TodoEditStore()

    private(set) var id: Todo.ID?

    override init(dispatcher: Dispatcher = .shared) {
        super.init(dispatcher: dispatcher)
    }

    override func onDispatch(_ action: TodoAction) {
        switch action {
        case let .startEditingTodo(id):
            self.id = id

        case .stopEditingTodo:
            self.id = nil

        default:
            return
        }

        emitChange()
    }
}
