//
//  Result.swift
//  MVPSample
//
//  Created by 田中賢治 on 2018/06/25.
//  Copyright © 2018年 田中賢治. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
