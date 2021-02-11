//
// Created by Kenji Tanaka on 2018/10/22.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit
import XCTest
@testable import NCMVVMSample

class FakeModel: ModelProtocol {
    var result: Result<Void>?

    func validate(idText: String?, passwordText: String?) -> Result<Void> {
        guard let result = result else {
            fatalError("validationResult has not been set.")
        }

        return result
    }
}

class ViewModelTests: XCTestCase {
    private var changedText: String?
    private var changedColor: UIColor?

    private let notificationCenter = NotificationCenter()
    private var fakeModel: FakeModel!
    private var viewModel: ViewModel!

    func test_changeValidationTextAndColor() {
        XCTContext.runActivity(named: "バリデーションに成功する場合") { _ in
            // Given
            setup()
            fakeModel.result = .success(())

            // When
            viewModel.idPasswordChanged(id: "id", password: "password")

            // Then
            XCTAssertEqual("OK!!!", changedText)
            XCTAssertEqual(UIColor.green, changedColor)

            clean()
        }

        XCTContext.runActivity(named: "バリデーションに失敗する場合") { _ in
            XCTContext.runActivity(named: "idもpasswordも入力されていない場合") { _ in
                setup()
                fakeModel.result = .failure(ModelError.invalidIdAndPassword)

                viewModel.idPasswordChanged(id: nil, password: nil)

                XCTAssertEqual("IDとPasswordが未入力です。", changedText)
                XCTAssertEqual(UIColor.red, changedColor)

                clean()
            }

            XCTContext.runActivity(named: "idが入力されておらず、passwordが入力されている場合") { _ in
                setup()
                fakeModel.result = .failure(ModelError.invalidId)

                viewModel.idPasswordChanged(id: nil, password: "password")

                XCTAssertEqual("IDが未入力です。", changedText)
                XCTAssertEqual(UIColor.red, changedColor)

                clean()
            }

            XCTContext.runActivity(named: "idが入力されていて、passwordが入力されていない場合") { _ in
                setup()
                fakeModel.result = .failure(ModelError.invalidPassword)

                viewModel.idPasswordChanged(id: "id", password: nil)

                XCTAssertEqual("Passwordが未入力です。", changedText)
                XCTAssertEqual(UIColor.red, changedColor)

                clean()
            }
        }
    }

    @objc private func changeTextReceiver(notification: Notification) {
        guard let text = notification.object as? String else {
            XCTFail("Fail to convert text.")
            fatalError()
        }

        changedText = text
    }

    @objc private func changeColorReceiver(notification: Notification) {
        guard let color = notification.object as? UIColor else {
            XCTFail("Fail to convert color.")
            fatalError()
        }

        changedColor = color
    }

    private func setup() {
        fakeModel = FakeModel()
        viewModel = ViewModel(
                notificationCenter: notificationCenter,
                model: fakeModel
        )

        notificationCenter.addObserver(
                self,
                selector: #selector(changeTextReceiver),
                name: viewModel.changeText,
                object: nil)
        notificationCenter.addObserver(
                self,
                selector: #selector(changeColorReceiver),
                name: viewModel.changeColor,
                object: nil)
    }

    private func clean() {
        fakeModel = nil
        viewModel = nil
    }
}
