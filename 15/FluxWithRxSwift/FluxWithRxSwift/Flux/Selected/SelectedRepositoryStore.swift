//
//  SelectedRepositoryStore.swift
//  FluxWithRxSwift
//
//  Created by marty-suzuki on 2018/09/16.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class SelectedRepositoryStore {
    static let shared = SelectedRepositoryStore()

    private let _repository = BehaviorRelay<GitHub.Repository?>(value: nil)

    private let disposeBag = DisposeBag()

    init(dispatcher: SelectedRepositoryDispatcher = .shared) {
        dispatcher.repository
            .bind(to: _repository)
            .disposed(by: disposeBag)
    }
}

// MARK: - Values

extension SelectedRepositoryStore {
    var repository: GitHub.Repository? {
        return _repository.value
    }
}

// MARK: - Observables

extension SelectedRepositoryStore {
    var repositoryObservable: Observable<GitHub.Repository?> {
        return _repository.asObservable()
    }
}
