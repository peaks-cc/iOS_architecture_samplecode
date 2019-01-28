//
//  Extension.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol ExtensionCompatible {
    associatedtype ExtensionCompatibleType
    static var `extension`: Extension<ExtensionCompatibleType>.Type { get }
    var `extension`: Extension<ExtensionCompatibleType> { get }
}

extension ExtensionCompatible {
    static var `extension`: Extension<Self>.Type {
        return  Extension<Self>.self
    }

    var `extension`: Extension<Self> {
        return Extension<Self>(base: self)
    }
}

struct Extension<Base> {
    let base: Base
}
