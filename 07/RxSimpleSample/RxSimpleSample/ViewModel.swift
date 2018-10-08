//
//  ViewModel.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var validationText: Observable<String> { get }
}

class ViewModel {
    let validationText: Observable<String>

    private var _validationText = BehaviorRelay<String>(value: "IDとパスワードを入力してください。")
    private let disposeBag = DisposeBag()

    init(idTextObservable: Observable<String?>, passwordTextObservable: Observable<String?>, model: ModelProtocol) {
        self.validationText = _validationText.map { $0 }

        Observable.combineLatest(idTextObservable, passwordTextObservable)
            .flatMap { idText, passwordText -> Observable<String> in
                let result = model.validate(idText: idText, passwordText: passwordText)
                switch result {
                case .none:
                    return .just("OK!!!")
                case .some(let error):
                    switch error {
                    case .invalidIdAndPassword:
                        return .just("IDとPasswordが未入力です。")
                    case .invalidId:
                        return .just("IDが未入力です。")
                    case .invalidPassword:
                        return .just("Passwordが未入力です。")
                    }
                }
            }
            .bind(to: _validationText)
            .disposed(by: disposeBag)
    }
}
