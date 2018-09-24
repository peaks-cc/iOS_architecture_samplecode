//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import Foundation

protocol SearchUserRouterProtocol {
    func transitionToUserDetail(user: User)
}

class SearchUserRouter: SearchUserRouterProtocol {
    private(set) weak var view: SearchUserViewProtocol!

    init(view: SearchUserViewProtocol) {
        self.view = view
    }

    func transitionToUserDetail(user: User) {

    }
}
