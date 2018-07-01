//
//  TodoEditViewController.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class TodoEditViewController: UIViewController {
    private enum EditType {
        case new
        case update(id: Todo.ID)
    }

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var textField: UITextField!

    private let todoStore: TodoStore
    private let draftStore: TodoDraftStore
    private let editStore: TodoEditStore
    private let actionCreator: TodoActionCreator
    private let notificationCenter: NotificationCenter

    private lazy var textDidChangeObserver: NSObjectProtocol = {
        let textDidChange: (Notification) -> () = { [weak self] notification in
            guard
                notification.name == .UITextFieldTextDidChange,
                let me = self,
                let text = me.textField.text
            else {
                return
            }
            me.actionCreator.updateDraft(text: text)
        }

        return self.notificationCenter.addObserver(forName: .UITextFieldTextDidChange,
                                                   object: nil,
                                                   queue: nil,
                                                   using: textDidChange)
    }()

    private let editType: EditType

    init(todoStore: TodoStore,
         draftStore: TodoDraftStore,
         editStore: TodoEditStore,
         actionCreator: TodoActionCreator,
         notificationCenter: NotificationCenter = .default) {
        self.todoStore = todoStore
        self.draftStore = draftStore
        self.editStore = editStore
        self.actionCreator = actionCreator
        self.notificationCenter = notificationCenter

        if let id = editStore.id {
            self.editType = .update(id: id)
        } else {
            self.editType = .new
        }

        super.init(nibName: "TodoEditViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationCenter.removeObserver(textDidChangeObserver)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch editType {
        case .new:
            title = "Add Todo"
            doneButton.setTitle("Add", for: .normal)
        case let .update(id):
            title = "Update Todo"
            doneButton.setTitle("Update", for: .normal)

            if let todo = todoStore.todos.first(where: { $0.id == id }) {
                textField.text = todo.text
            }
        }

        _ = textDidChangeObserver
    }

    @IBAction private func cancelButtonTap(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func doneButtonTap(_ button: UIButton) {
        if let text = draftStore.text {
            switch editType {
            case .new:
                actionCreator.addTodo(text: text)
            case let .update(id):
                actionCreator.editTodo(id: id, text: text)
                actionCreator.stopEditingTodo()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
