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

    private let _validationText = BehaviorRelay<String>(value: "IDとパスワードを入力してください。")
    private let disposeBag = DisposeBag()

    init(idTextObservable: Observable<String?>, passwordTextObservable: Observable<String?>, model: ModelProtocol) {
        self.validationText = _validationText.map { $0 }

        Observable.combineLatest(idTextObservable, passwordTextObservable)
            .map { idText, passwordText -> String in
                let result = model.validate(idText: idText, passwordText: passwordText)
                switch result {
                case .none:
                    return "OK!!!"
                case .some(let error):
                    return error.errorText
                }
            }
            .bind(to: _validationText)
            .disposed(by: disposeBag)
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です。"
        }
    }
}
