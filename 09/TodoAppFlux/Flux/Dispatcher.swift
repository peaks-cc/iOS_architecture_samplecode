//
//  Dispatcher.swift
//  Flux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation.NSLock

public typealias DispatchToken = String

public final class Dispatcher {
    public static let shared = Dispatcher()

    private let recursiveLock: NSRecursiveLock
    private var callbacks: [DispatchToken: (Action) -> ()]
    private(set) var isDispatching: Bool
    private var isHandled: [DispatchToken: Bool]
    private var isPending: [DispatchToken: Bool]
    private var lastID: UInt
    private var pendingAction: Action?

    public init() {
        self.recursiveLock = NSRecursiveLock()
        self.callbacks = [:]
        self.isDispatching = false
        self.isHandled = [:]
        self.isPending = [:]
        self.lastID = 1
    }

    public func register(callback: @escaping (Action) -> ()) -> DispatchToken {
        recursiveLock.lock()
        defer { recursiveLock.unlock() }
        let token =  "ID_" + "\(lastID)"
        lastID += 1
        callbacks[token] = callback
        return token
    }

    public func unregister(token: DispatchToken) {
        callbacks.removeValue(forKey: token)
    }

    public func dispatch(_ action: Action) {
        recursiveLock.lock()
        defer { recursiveLock.unlock() }
        startDispatching(action: action)
        callbacks.forEach { token, _ in
            if isPending[token] == true {
                return
            }
            invokeCallback(token: token)
        }
        stopDispatching()
    }

    public func waitFor(tokens: [DispatchToken]) {
        tokens.forEach { token in
            if isPending[token] == true {
                return
            }
            invokeCallback(token: token)
        }
    }

    private func invokeCallback(token: DispatchToken) {
        isPending[token] = true
        if let action = pendingAction {
            callbacks[token]?(action)
        }
        isHandled[token] = true
    }

    private func startDispatching(action: Action) {
        callbacks.forEach { token, _ in
            isPending[token] = false
            isHandled[token] = false
        }
        pendingAction = action
        isDispatching = true
    }

    private func stopDispatching() {
        pendingAction = nil
        isDispatching = false
    }
}
