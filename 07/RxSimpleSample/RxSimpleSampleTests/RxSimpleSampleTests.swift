//
//  RxSimpleSampleTests.swift
//  RxSimpleSampleTests
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import XCTest
@testable import RxSimpleSample

class RxSimpleSampleTests: XCTestCase {

    func testValidation() {
        let model = Model()

        XCTAssertEqual(
            ModelError.invalidIdAndPassword,
            model.validate(idText: nil, passwordText: nil)
        )

        XCTAssertEqual(
            ModelError.invalidIdAndPassword,
            model.validate(idText: "", passwordText: "")
        )

        XCTAssertEqual(
            ModelError.invalidId,
            model.validate(idText: nil, passwordText: "password")
        )

        XCTAssertEqual(
            ModelError.invalidId,
            model.validate(idText: "", passwordText: "password")
        )

        XCTAssertEqual(
            ModelError.invalidPassword,
            model.validate(idText: "id", passwordText: nil)
        )

        XCTAssertEqual(
            ModelError.invalidPassword,
            model.validate(idText: "id", passwordText: "")
        )

        XCTAssertEqual(
            nil,
            model.validate(idText: "id", passwordText: "password")
        )
    }

}
