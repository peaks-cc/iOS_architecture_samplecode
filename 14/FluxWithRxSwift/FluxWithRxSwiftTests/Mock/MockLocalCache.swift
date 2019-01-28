//
//  MockLocalCache.swift
//  FluxWithRxSwiftTests
//
//  Created by 鈴木大貴 on 2018/08/15.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift
@testable import FluxWithRxSwift

final class MockLocalCache: LocalCacheable {
    let cache = BehaviorRelay<Any?>(value: nil)

    subscript<T: LocalCacheGettable & LocalCacheSettable>(key: LocalCacheKey<T>) -> T {
        get {
            return (cache.value as? T) ?? key.defaultValue
        }
        set(newValue) {
            cache.accept(newValue)
        }
    }
}
