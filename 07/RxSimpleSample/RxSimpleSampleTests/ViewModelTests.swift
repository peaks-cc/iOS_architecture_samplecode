//
// Created by Kenji Tanaka on 2018/10/22.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import XCTest
@testable import RxSimpleSample

class FakeModel: ModelProtocol {
    var result: Observable<Void>?

    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        guard let result = result else {
            fatalError("")
        }

        return result
    }
}

class ViewModelTests: XCTestCase {
    func test_changeTextAndColor() {
        let idTextObservable = PublishSubject<String?>()
        let passwordTextObservable = PublishSubject<String?>()
        let validationResult = PublishSubject<Void>()
        let model = FakeModel()
        model.result = validationResult

        let viewModel = ViewModel(
                idTextObservable: idTextObservable,
                passwordTextObservable: passwordTextObservable,
                model: model
        )

        let validationText = BehaviorRelay<String?>(value: nil)
        let disposable1 = viewModel.validationText
            .bind(to: validationText)
        defer {
            disposable1.dispose()
        }

        let loadLabelColor = BehaviorRelay<UIColor?>(value: nil)
        let disposable2 = viewModel.loadLabelColor
            .bind(to: loadLabelColor)
        defer {
            disposable2.dispose()
        }

        do {
            // 初回のcombineLatestをskip(1)しているので、イベントが発火しない・もしくは初期値
            idTextObservable.onNext("id")
            passwordTextObservable.onNext("password")
            validationResult.onNext(())
            XCTAssertEqual("IDとPasswordを入力してください。", validationText.value)
            XCTAssertNil(loadLabelColor.value)
        }

        do {
            // 2回目以降の発火で想定していた値が流れる
            passwordTextObservable.onNext("password")
            validationResult.onNext(())
            XCTAssertEqual("OK!!!", validationText.value)
            XCTAssertEqual(UIColor.green, loadLabelColor.value)
        }
    }
}
