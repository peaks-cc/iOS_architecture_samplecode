//
//  SearchUserPresenter.swift
//  RouterSample
//
//  Created by Kenji Tanaka on 2018/09/24.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import Foundation
import GitHub

protocol SearchUserPresenterProtocol {
    var numberOfUsers: Int { get }
    func user(forRow row: Int) -> User?
    func didSelectRow(at indexPath: IndexPath)
    func didTapSearchButton(text: String)
}

class SearchUserPresenter: SearchUserPresenterProtocol {
    private(set) var users: [User] = []

    private weak var view: SearchUserViewProtocol!
    private var model: SearchUserModelProtocol!
    private var router: SearchUserRouterProtocol!

    init(view: SearchUserViewProtocol, model: SearchUserModelProtocol, router: SearchUserRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }

    var numberOfUsers: Int {
        return users.count
    }

    func user(forRow row: Int) -> User? {
        guard row < users.count else { return nil }
        return users[row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let user = user(forRow: indexPath.row) else { return }
        router.transitionToUserDetail(userName: user.login)
    }

    func didTapSearchButton(text: String) {
        let query = text
        model.fetchUser(query: query) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                
                DispatchQueue.main.async {
                    self?.view.reloadTableView()
                }
            case .failure(let error):
                // TODO: Error Handling
                ()
            }
        }
    }
}
