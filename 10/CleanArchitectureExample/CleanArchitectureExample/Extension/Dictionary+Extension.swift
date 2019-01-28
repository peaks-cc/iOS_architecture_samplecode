//
//  Dictionary+Extension.swift
//  CleanArchitectureExample
//
//  Created by Daiki Matsudate on 2018/07/22.
//  Copyright © 2018 Daiki Matsudate. All rights reserved.
//

import Foundation

//TODO: Remove at Swift 4.x
extension Dictionary {
    public func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        return try self.reduce(into: [Key: T](), { (result, x) in
            if let value = try transform(x.value) {
                result[x.key] = value
            }
        })
    }
}
