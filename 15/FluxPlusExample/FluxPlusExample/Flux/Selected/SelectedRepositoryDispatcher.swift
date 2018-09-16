//
//  SelectedRepositoryDispatcher.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SelectedRepositoryDispatcher {
    static let shared = SelectedRepositoryDispatcher()

    let repository = PublishRelay<GitHub.Repository?>()
}
