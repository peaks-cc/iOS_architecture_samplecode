//
//  Model.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import Foundation

enum ModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    func validate(idText: String?, passwordText: String?) throws
}

class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) throws {
        switch (idText, passwordText) {
        case (.none, .none):
            throw ModelError.invalidIdAndPassword
        case (.none, .some):
            throw ModelError.invalidId
        case (.some, .none):
            throw ModelError.invalidPassword
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                throw ModelError.invalidIdAndPassword
            case (false, false):
                return
            case (true, false):
                throw ModelError.invalidId
            case (false, true):
                throw ModelError.invalidPassword
            }
        }
    }
}
