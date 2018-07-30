//
//  Store.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

typealias Subscription = NSObjectProtocol

class Store {
    private lazy var dispatchToken: DispatchToken = {
        return self.dispatcher.register(callback: { [weak self] action in
            self?.invokeOnDispatch(action)
        })
    }()

    private let notificationCenter: NotificationCenter
    private let storeChangedNotificationName = Notification.Name("store-changed-notification")

    private(set) var changed: Bool
    let dispatcher: Dispatcher

    deinit {
        dispatcher.unregister(dispatchToken)
    }

    init(dispatcher: Dispatcher) {
        self.changed = false
        self.dispatcher = dispatcher
        self.notificationCenter = NotificationCenter()
        _ = dispatchToken
    }

    private func invokeOnDispatch(_ action: Action) {
        self.changed = false

        onDispatch(action)

        if changed {
            notificationCenter.post(name: storeChangedNotificationName, object: nil)
        }
    }

    func onDispatch(_ action: Action) {
        fatalError("must override")
    }

    func emitChange() {
        changed = true
    }

    func addListener(callback: @escaping () -> ()) -> Subscription {
        let using: (Notification) -> () = { [storeChangedNotificationName] notification in
            if notification.name == storeChangedNotificationName {
                callback()
            }
        }
        return notificationCenter.addObserver(forName: storeChangedNotificationName,
                                              object: nil,
                                              queue: nil,
                                              using: using)
    }

    func removeListener(_ subscription: Subscription) {
        notificationCenter.removeObserver(subscription)
    }
}
