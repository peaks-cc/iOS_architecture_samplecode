//
//  GitHub.Result.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

extension Result {
    var element: T? {
        if case let .success(element) = self {
            return element
        } else {
            return nil
        }
    }

    var error: Error? {
        if case let .failure(error) = self {
            return error
        } else {
            return nil
        }
    }
}
