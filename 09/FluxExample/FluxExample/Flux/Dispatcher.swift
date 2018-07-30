//
//  Dispatcher.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/30.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

typealias DispatchToken = String

final class Dispatcher {

    static let shared = Dispatcher()

    let recursiveLock: NSRecursiveLock
    private var callbacks: [DispatchToken: (Action) -> ()]

    init() {
        self.recursiveLock = NSRecursiveLock()
        self.callbacks = [:]
    }

    func register(callback: @escaping (Action) -> ()) -> DispatchToken {
        recursiveLock.lock(); defer { recursiveLock.unlock() }

        let token =  UUID().uuidString
        callbacks[token] = callback
        return token
    }

    func unregister(_ token: DispatchToken) {
        recursiveLock.lock(); defer { recursiveLock.unlock() }

        callbacks.removeValue(forKey: token)
    }

    func dispatch(_ action: Action) {
        recursiveLock.lock(); defer { recursiveLock.unlock() }
        
        callbacks.forEach { _, callback in
            callback(action)
        }
    }
}
