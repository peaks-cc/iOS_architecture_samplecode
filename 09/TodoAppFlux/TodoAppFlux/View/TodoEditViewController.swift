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
        case edit(id: Todo.ID)
    }

    private lazy var cancelButton = UIBarButtonItem(title: "Cancel",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(self.cancelButtonTap(_:)))
    private lazy var addButton = UIBarButtonItem(title: "Add",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(self.addButtonTap(_:)))
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.placeholder = "What needs to be done?"
        }
    }

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
            self.editType = .edit(id: id)
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

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton

        let typeName: String
        switch editType {
        case .new:
            typeName = "Add"
        case let .edit(id):
            typeName = "Edit"

            if let todo = todoStore.todos.first(where: { $0.id == id }) {
                textField.text = todo.text
            }
        }

        title = "\(typeName) Todo"
        addButton.title = typeName

        _ = textDidChangeObserver
    }

    @objc private func cancelButtonTap(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func addButtonTap(_ button: UIBarButtonItem) {
        if let text = draftStore.text {
            switch editType {
            case .new:
                actionCreator.addTodo(text: text)
            case let .edit(id):
                actionCreator.editTodo(id: id, text: text)
                actionCreator.stopEditingTodo()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
