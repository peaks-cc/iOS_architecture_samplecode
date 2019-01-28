//
//  LocalCacheKey.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/08/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub

protocol LocalCacheKeys {}

struct LocalCacheKey<Value: LocalCacheValue>: LocalCacheKeys {
    let rawValue: String
    let defaultValue: Value

    fileprivate init(_ rawValue: String, defaultValue: Value) {
        self.rawValue = rawValue
        self.defaultValue = defaultValue
    }
}

extension LocalCacheKeys {
    static var favorites: LocalCacheKey<[GitHub.Repository]> {
        return LocalCacheKey("favorites", defaultValue: [])
    }
}

extension GitHub.Repository: LocalCacheValue {}
