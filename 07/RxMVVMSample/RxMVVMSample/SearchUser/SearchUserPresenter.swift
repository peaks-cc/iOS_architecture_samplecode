//
//  SearchUserPresenter.swift
//  MVPSample
//
//  Created by Kenji Tanaka on 2018/09/24.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//protocol SearchUserPresenterProtocol {
//    var numberOfUsers: Int { get }
//    func user(forRow row: Int) -> User?
//    func didSelectRow(at indexPath: IndexPath)
//    func didTapSearchButton(text: String?)
//}
//
//class SearchUserPresenter: SearchUserPresenterProtocol {
//    private(set) var users = BehaviorRelay<[User]>(value: [])
//
//    private weak var view: SearchUserViewProtocol!
//    private var model: SearchUserModelProtocol!
//
//    init(view: SearchUserViewProtocol, model: SearchUserModelProtocol) {
//        self.view = view
//        self.model = model
//    }
//
//    var numberOfUsers: Int {
//        return users.value.count
//    }
//
//    func user(forRow row: Int) -> User? {
//        guard row < users.value.count else { return nil }
//        return users.value[row]
//    }
//
//    func didSelectRow(at indexPath: IndexPath) {
//        guard let user = user(forRow: indexPath.row) else { return }
//        view.transitionToUserDetail(userName: user.login)
//    }
//
//    func didTapSearchButton(text: String?) {
//        guard let query = text else { return }
//        guard !query.isEmpty else { return }
//
//        model.fetchUser(query: query) { [weak self] result in
//            switch result {
//            case .success(let users):
//                self?.users.accept(users)
//                
//                DispatchQueue.main.async {
//                    self?.view.reloadTableView()
//                }
//            case .failure(let error):
//                // TODO: Error Handling
//                ()
//            }
//        }
//    }
//}
