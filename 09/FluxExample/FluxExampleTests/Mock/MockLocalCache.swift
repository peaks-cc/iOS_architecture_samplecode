//
//  MockLocalCache.swift
//  FluxExampleTests
//
//  Created by marty-suzuki on 2018/08/04.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
@testable import FluxExample

final class MockLocalCache: LocalCacheable {
    var setterValueHandler: ((Any) -> ())?
    var getterValueHandler: (() -> (Any))?

    subscript<T: LocalCacheGettable & LocalCacheSettable>(key: LocalCacheKey<T>) -> T {
        get {
            return (getterValueHandler?() as? T) ?? key.defaultValue
        }
        set(newValue) {
            setterValueHandler?(newValue)
        }
    }
}
