//
//  LocalCache.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/08/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol LocalCacheSettable {
    static func set(key: String, value: Self?, cache: LocalCache)
    static func set(key: String, array: [Self], cache: LocalCache)
}

protocol LocalCacheGettable {
    static func get(key: String, cache: LocalCache) -> Self?
    static func getArray(key: String, cache: LocalCache) -> [Self]?
}

typealias LocalCacheValue = LocalCacheGettable & LocalCacheSettable

protocol LocalCacheable: class {
    subscript<T: LocalCacheValue>(_ key: LocalCacheKey<T>) -> T { get set }
}

final class LocalCache: LocalCacheable {
    static let shared = LocalCache()

    private let userDefaults = UserDefaults.standard

    subscript<T: LocalCacheValue>(_ key: LocalCacheKey<T>) -> T {
        set {
            T.set(key: key.rawValue, value: newValue, cache: self)
        }
        get {
            return T.get(key: key.rawValue, cache: self) ?? key.defaultValue
        }
    }

    private init() {}
}

extension LocalCache {
    fileprivate func getDecodableObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    fileprivate func setEncodableObject<T: Encodable>(forKey key: String, value: T) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        userDefaults.set(data, forKey: key)
    }

    fileprivate func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

extension LocalCacheSettable where Self: Encodable {
    static func set(key: String, value: Self?, cache: LocalCache) {
        guard let value = value else {
            cache.removeObject(forKey: key)
            return
        }
        cache.setEncodableObject(forKey: key, value: value)
    }

    static func set(key: String, array: [Self], cache: LocalCache) {
        if array.isEmpty {
            cache.removeObject(forKey: key)
            return
        }
        cache.setEncodableObject(forKey: key, value: array)
    }
}

extension LocalCacheGettable where Self: Decodable {
    static func get(key: String, cache: LocalCache) -> Self? {
        return cache.getDecodableObject(forKey: key) as Self?
    }

    static func getArray(key: String, cache: LocalCache) -> [Self]? {
        return cache.getDecodableObject(forKey: key) as [Self]?
    }
}

extension Array: LocalCacheValue where Element: LocalCacheValue {
    static func get(key: String, cache: LocalCache) -> [Element]? {
        return Element.getArray(key: key, cache: cache)
    }

    static func getArray(key: String, cache: LocalCache) -> [[Element]]? {
        assertionFailure("two dimensional array not supported yet")
        return nil
    }

    static func set(key: String, value: [Element]?, cache: LocalCache) {
        guard let value = value else {
            cache.removeObject(forKey: key)
            return
        }
        Element.set(key: key, array: value, cache: cache)
    }

    static func set(key: String, array: [[Element]], cache: LocalCache) {
        assertionFailure("two dimensional array not supported yet")
    }
}
