//
//  Store.swift
//  Flux
//
//  Created by marty-suzuki on 2018/07/01.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

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

open class Store<ActionType: Action> {
    private lazy var dispatchToken: DispatchToken = {
        return self.dispatcher.register(callback: { [weak self] action in
            guard let action = action as? ActionType else {
                return
            }
            self?.invokeOnDispatch(action)
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

    private func invokeOnDispatch(_ action: ActionType) {
        self.changed = false

        onDispatch(action)

        if changed {
            emitter.emit()
        }
    }

    open func onDispatch(_ action: ActionType) {
        // must override
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
