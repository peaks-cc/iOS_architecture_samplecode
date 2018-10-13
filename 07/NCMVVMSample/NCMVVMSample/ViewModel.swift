//
//  ViewModel.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let changeText = Notification.Name("changeText")
    static let changeColor = Notification.Name("changeColor")
}

class ViewModel {
    private let model: ModelProtocol
    init(model: ModelProtocol = Model()) {
        self.model = model
    }

    func idPasswordChanged(id: String?, password: String?) {
        let result = model.validate(idText: id, passwordText: password)
        
        switch result {
        case .success:
            NotificationCenter.default.post(name: .changeText, object: "OK!!!")
            NotificationCenter.default.post(name: .changeColor, object: UIColor.green)
        case .failure(let error as ModelError):
            NotificationCenter.default.post(name: .changeText, object: error.errorText)
            NotificationCenter.default.post(name: .changeColor, object: UIColor.red)
        case _:
            fatalError("Unexpected pattern.")
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
