//
//  Dispatcher.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/10/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class Dispatcher {

    static let shared = Dispatcher()

    private let _action = PublishRelay<Action>()

    init() {}

    func register(callback: @escaping (Action) -> ()) -> Disposable {
        return _action.subscribe(onNext: callback)
    }

    func dispatch(_ action: Action) {
        _action.accept(action)
    }
}
