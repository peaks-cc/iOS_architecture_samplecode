//
//  ViewController.swift
//  TodoAppFlux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import Flux

final class TodoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                     target: self,
                                                     action: #selector(self.addButtonTap(_:)))
    private lazy var editAllButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                         target: self,
                                                         action: #selector(self.editAllButtonTap(_:)))

    private let todoStore: TodoStore
    private let draftStore: TodoDraftStore
    private let editStore: TodoEditStore
    private let actionCreator: TodoActionCreator

    private let cellIdentifier = "Cell"
    private lazy var todoStoreSubscription: Subscription = {
        return todoStore.addListener(callback: { [weak self] in
            self?.todoStoreChanged()
        })
    }()

    init(todoStore: TodoStore,
         draftStore: TodoDraftStore,
         editStore: TodoEditStore,
         actionCreator: TodoActionCreator) {
        self.todoStore = todoStore
        self.draftStore = draftStore
        self.editStore = editStore
        self.actionCreator = actionCreator

        super.init(nibName: "TodoListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        todoStore.removeListener(todoStoreSubscription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editAllButtonItem
        navigationItem.rightBarButtonItem = addButtonItem

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        updateEditAllButtonEnabled()

        _ = todoStoreSubscription
    }

    @objc private func addButtonTap(_ button: UIBarButtonItem) {
        presentEditViewController()
    }

    @objc private func editAllButtonTap(_ button: UIBarButtonItem) {
        showEditAllActionSheet()
    }

    private func todoStoreChanged() {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        tableView.endUpdates()
        updateEditAllButtonEnabled()
    }

    private func updateEditAllButtonEnabled() {
        editAllButtonItem.isEnabled = todoStore.todos.count > 0
    }

    private func presentEditViewController() {
        let editViewController = TodoEditViewController(todoStore: todoStore,
                                                        draftStore: draftStore,
                                                        editStore: editStore,
                                                        actionCreator: actionCreator)
        let navigationController = UINavigationController(rootViewController: editViewController)
        present(navigationController, animated: true, completion: nil)
    }

    private func showEditAllActionSheet() {
        let actionSheet = UIAlertController(title: "Select Action",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Incomplete All", style: .default) { [weak self] _ in
            self?.actionCreator.toggleAllTodos()
        })
        actionSheet.addAction(UIAlertAction(title: "Remove All Completed", style: .destructive) { [weak self] _ in
            self?.actionCreator.deleteCompletedTodos()
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }

    private func showEditActionSheet(with todo: Todo) {
        let actionSheet = UIAlertController(title: "Select Action",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default) { [weak self, todo] _ in
            self?.actionCreator.startEditingTodo(id: todo.id)
            self?.presentEditViewController()
        })
        let completeTitle = todo.isCompleted ? "Incomplete" : "Complete"
        actionSheet.addAction(UIAlertAction(title: completeTitle, style: .default) { [weak self, todo] _ in
            self?.actionCreator.toggleTodo(id: todo.id)
        })
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self, todo] _ in
            self?.actionCreator.deleteTodo(id: todo.id)
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoStore.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let todo = todoStore.todos[indexPath.row]
        let completed = todo.isCompleted ? "☑︎" : "☐"
        cell.textLabel?.text = "\(completed) \(todo.text)"
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let todo = todoStore.todos[indexPath.row]
        showEditActionSheet(with: todo)
    }
}
