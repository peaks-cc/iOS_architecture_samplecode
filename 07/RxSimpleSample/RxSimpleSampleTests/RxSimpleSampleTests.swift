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

        do {
            try model.validate(idText: nil, passwordText: nil)
        } catch {
            XCTAssertEqual(ModelError.invalidIdAndPassword, error as! ModelError)
        }

        do {
            try model.validate(idText: "", passwordText: "")
        } catch {
            XCTAssertEqual(ModelError.invalidIdAndPassword, error as! ModelError)
        }

        do {
            try model.validate(idText: nil, passwordText: "password")
        } catch {
            XCTAssertEqual(ModelError.invalidId, error as! ModelError)
        }

        do {
            try model.validate(idText: "", passwordText: "password")
        } catch {
            XCTAssertEqual(ModelError.invalidId, error as! ModelError)
        }

        do {
            try model.validate(idText: "id", passwordText: nil)
        } catch {
            XCTAssertEqual(ModelError.invalidPassword, error as! ModelError)
        }

        do {
            try model.validate(idText: "id", passwordText: "")
        } catch {
            XCTAssertEqual(ModelError.invalidPassword, error as! ModelError)
        }

        XCTAssertNoThrow(try model.validate(idText: "id", passwordText: "password"))
    }

}
