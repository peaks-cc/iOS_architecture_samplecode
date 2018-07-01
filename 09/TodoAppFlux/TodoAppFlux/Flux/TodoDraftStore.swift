//
//  TodoDraftStore.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Flux

final class TodoDraftStore: Store {
    static let shared = TodoDraftStore()

    private(set) var text: String?

    override init(dispatcher: Dispatcher = .shared) {
        super.init(dispatcher: dispatcher)
    }

    func onDispatch(_ action: Action) {
        guard let action = action as? TodoAction else {
            return
        }

        switch action {
        case .addTodo,
             .stopEditingTodo:
            self.text = nil

        case let .updateDraft(text):
            self.text = text

        default:
            return
        }

        emitChange()
    }
}
