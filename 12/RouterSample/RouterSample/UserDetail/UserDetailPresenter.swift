//
// Created by Kenji Tanaka on 2018/09/26.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation
import GitHub

protocol UserDetailPresenterProtocol {
    var repositories: [Repository] { get }
    func repository(forRow row: Int) -> Repository?
    func viewDidLoad()
}

class UserDetailPresenter: UserDetailPresenterProtocol {
    private var userName: String
    private(set) var repositories: [Repository] = []

    private weak var view: UserDetailViewProtocol!
    private let model: UserDetailModelProtocol

    init(userName: String, view: UserDetailViewProtocol, model: UserDetailModelProtocol) {
        self.userName = userName
        self.view = view
        self.model = model
    }

    func repository(forRow row: Int) -> Repository? {
        guard row < repositories.count else { return nil }
        return repositories[row]
    }

    func viewDidLoad() {
        model.fetchRepositories() { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories

                DispatchQueue.main.async {
                    self?.view.reloadTableView()
                }
            case .failure:
                // TODO: Error Handling
                ()
            }
        }
    }
}
