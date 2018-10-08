//
//  ViewModel.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var validationText: Observable<String> { get }
}

class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>

    private let _validationText = BehaviorRelay<String>(value: "IDとパスワードを入力してください。")
    private let disposeBag = DisposeBag()

    init(idTextObservable: Observable<String?>, passwordTextObservable: Observable<String?>, model: ModelProtocol) {
        self.validationText = _validationText.map { $0 }

        Observable.combineLatest(idTextObservable, passwordTextObservable)
            .map { idText, passwordText -> String in
                do {
                    try model.validate(idText: idText, passwordText: passwordText)
                } catch {
                    guard let error = error as? ModelError else { fatalError("Unexpected Error.") }
                    return error.errorText
                }

                return "OK!!!"
            }
            .bind(to: _validationText)
            .disposed(by: disposeBag)

        // FIXME: _validationTextの方のロジックと統一したい
        self.loadLabelColor = Observable.combineLatest(idTextObservable, passwordTextObservable)
            .map { idText, passwordText -> UIColor in
                do {
                    try model.validate(idText: idText, passwordText: passwordText)
                } catch {
                    return UIColor.red
                }

                return UIColor.green
        }
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
