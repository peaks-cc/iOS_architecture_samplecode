//
//  Store.swift
//  Flux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

public protocol StoreProtocol {
    func onDispatch(_ action: Action)
}

public typealias Store = FluxStore & StoreProtocol
public typealias Subscription = String

final class Emitter {
    private var subscriptions: [Subscription: () -> ()]

    init() {
        self.subscriptions = [:]
    }

    func addListener(handler: @escaping () -> ()) -> Subscription {
        let subscription = UUID().uuidString
        subscriptions[subscription] = handler
        return subscription
    }

    func removeListener(_ subscription: Subscription) {
        subscriptions.removeValue(forKey: subscription)
    }

    func emit() {
        subscriptions.forEach { _, handler in
            handler()
        }
    }
}

open class FluxStore {
    private lazy var dispatchToken: DispatchToken = {
        return self.dispatcher.register(callback: { [weak self] payload in
            self?.invokeOnDispatch(payload)
        })
    }()

    private(set) var changed: Bool
    let dispatcher: Dispatcher
    let emitter: Emitter

    deinit {
        dispatcher.unregister(token: dispatchToken)
    }

    public init(dispatcher: Dispatcher) {
        self.changed = false
        self.dispatcher = dispatcher
        self.emitter = Emitter()
        _ = dispatchToken
    }

    private func invokeOnDispatch(_ payload: Action) {
        self.changed = false
        if let onDispatch = (self as? StoreProtocol)?.onDispatch {
            onDispatch(payload)
        }
        if changed {
            emitter.emit()
        }
    }

    public func emitChange() {
        changed = true
    }

    public func addListener(callback: @escaping () -> ()) -> Subscription {
        return emitter.addListener(handler: callback)
    }

    public func removeListener(_ subscription: Subscription) {
        emitter.removeListener(subscription)
    }
}
