//
// Created by Kenji Tanaka on 2018/10/22.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
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
        let idTextObservable = Observable<String?>.create { observer in
            observer.onNext("id")
            observer.onCompleted()
            return Disposables.create()
        }
        let passwordTextObservable = Observable<String?>.create { observer in
            observer.onNext("password")
            observer.onCompleted()
            return Disposables.create()
        }
        let model = FakeModel()
        model.result = Observable.just(())

        let viewModel = ViewModel(
                idTextObservable: idTextObservable,
                passwordTextObservable: passwordTextObservable,
                model: model
        )

        viewModel.validationText.subscribe { text in
            XCTAssertEqual("OK!!!", text.element)
        }.dispose()

        viewModel.loadLabelColor.subscribe { color in
            XCTAssertEqual(UIColor.green, color.element)
        }.dispose()
    }
}
