//
//  Result.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/19.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
