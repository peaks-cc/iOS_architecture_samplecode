//
//  SelectedRepositoryStore.swift
//  FluxPlusExample
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SelectedRepositoryStore {
    static let shared = SelectedRepositoryStore()

    let repository: Property<GitHub.Repository?>
    private let _repository = BehaviorRelay<GitHub.Repository?>(value: nil)

    private let disposeBag = DisposeBag()

    init(dispatcher: SelectedRepositoryDispatcher = .shared) {
        self.repository = Property(_repository)

        dispatcher.repository
            .bind(to: _repository)
            .disposed(by: disposeBag)
    }
}
