//
//  SelectedRepositoryActionCreator.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxSwift
import RxCocoa

final class SelectedRepositoryActionCreator {

    static let shared = SelectedRepositoryActionCreator()

    private let dispatcher: SelectedRepositoryDispatcher

    init(dispatcher: SelectedRepositoryDispatcher = .shared) {
        self.dispatcher = dispatcher
    }

     func setSelectedRepository(_ repository: GitHub.Repository?) {
        dispatcher.repository.accept(repository)
    }
}
