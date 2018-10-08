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
    func validate(idText: String?, passwordText: String?) -> ModelError?
}

class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> ModelError? {
        switch (idText, passwordText) {
        case (.none, .none):
            return .invalidIdAndPassword
        case (.none, .some):
            return .invalidId
        case (.some, .none):
            return .invalidPassword
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return .invalidIdAndPassword
            case (false, false):
                return nil
            case (true, false):
                return .invalidId
            case (false, true):
                return .invalidPassword
            }
        }
    }
}
