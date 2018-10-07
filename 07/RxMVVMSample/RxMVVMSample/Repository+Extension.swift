//
//  Repository+Extension.swift
//  RxMVVMSample
//
//  Created by Kenji Tanaka on 2018/10/06.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import GitHub

extension GitHub.Repository {
    struct Name {
        let rawValue: String
    }

    var strictName: Name {
        return Name(rawValue: name)
    }
}
