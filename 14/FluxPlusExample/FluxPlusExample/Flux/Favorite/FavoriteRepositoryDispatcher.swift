//
//  FavoriteRepositoryDispatcher.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class FavoriteRepositoryDispatcher {
    static let shared = FavoriteRepositoryDispatcher()

    let repositories = PublishRelay<[GitHub.Repository]>()
}

