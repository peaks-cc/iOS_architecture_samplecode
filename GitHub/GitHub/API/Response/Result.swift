//
//  Result.swift
//  GitHub
//
//  Created by 鈴木大貴 on 2018/08/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case failure(Error)
}
