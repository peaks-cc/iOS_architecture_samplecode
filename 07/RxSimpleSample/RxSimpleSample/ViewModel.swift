//
//  ViewModel.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift
//import RxCocoa

protocol ViewModelProtocol {
    var validationText: Observable<String> { get }
}

class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>

    init(idTextObservable: Observable<String?>, passwordTextObservable: Observable<String?>, model: ModelProtocol) {

        let event = Observable.combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .flatMap { idText, passwordText -> Observable<Void> in
                return model
                    .validate(idText: idText, passwordText: passwordText)
            }
            .share()

        // ②flatMap内にmapとcatchErrorをまとめると、mapでStringとUIColor両方を返す必要があるため、StringとUIColorを分けたストリームで扱えない
//        let event = Observable.combineLatest(idTextObservable, passwordTextObservable)
//            .skip(1)
//            .flatMap { idText, passwordText -> Observable<Void> in
//                return model
//                    .validate(idText: idText, passwordText: passwordText)
//                    .map { "OK!!!" }
//                    .catchError({ error -> Observable<String> in
//                        (error as? ModelError).flatMap { modelError -> Observable<String> in
//                            Observable.just(modelError.errorText)
//                            } ?? .empty()
//                    })
//            }
//            .share()

        // ①catchErrorの段階でonCompleteが呼ばれてしまうので、
        self.validationText = event
            .map { "OK!!!" }
            .catchError({ error -> Observable<String> in
                (error as? ModelError).flatMap { modelError -> Observable<String> in
                    Observable.just(modelError.errorText)
                } ?? .empty()
            })
            .startWith("IDとPasswordを入力してください。")

        self.loadLabelColor = event
            .map { UIColor.green }
            .catchError({ error -> Observable<UIColor> in
                (error as? ModelError).map { modelError -> Observable<UIColor> in
                    Observable.just(.red)
                } ?? .empty()
            })
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
