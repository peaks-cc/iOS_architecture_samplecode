//
//  Model.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Result<Void>
}

final class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Result<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return .failure(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return .failure(ModelError.invalidId)
        case (.some, .none):
            return .failure(ModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return .failure(ModelError.invalidIdAndPassword)
            case (false, false):
                return .success(())
            case (true, false):
                return .failure(ModelError.invalidId)
            case (false, true):
                return .failure(ModelError.invalidPassword)
            }
        }
    }
}
