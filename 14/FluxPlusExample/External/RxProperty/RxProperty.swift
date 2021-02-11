//
//  Property.swift
//  RxProperty
//
//  Created by Yasuhiro Inami on 2017-03-11.
//  Copyright © 2017 Yasuhiro Inami. All rights reserved.
//

import RxSwift
import RxRelay

/// A get-only `BehaviorRelay` that works similar to ReactiveSwift's `Property`.
///
/// - Note:
/// From ver 0.3.0, this class will no longer send `.completed` when deallocated.
///
/// - SeeAlso:
///     https://github.com/ReactiveCocoa/ReactiveSwift/blob/1.1.0/Sources/Property.swift
///     https://github.com/ReactiveX/RxSwift/pull/1118 (unmerged)
public final class Property<Element> {

    public typealias E = Element

    private let _behaviorRelay: BehaviorRelay<E>

    /// Gets current value.
    public var value: E {
        get {
            return _behaviorRelay.value
        }
    }

    /// Initializes with initial value.
    public init(_ value: E) {
        _behaviorRelay = BehaviorRelay(value: value)
    }

    /// Initializes with `BehaviorRelay`.
    public init(_ behaviorRelay: BehaviorRelay<E>) {
        _behaviorRelay = behaviorRelay
    }

    /// Initializes with `Observable` that must send at least one value synchronously.
    ///
    /// - Warning:
    /// If `unsafeObservable` fails sending at least one value synchronously,
    /// a fatal error would be raised.
    ///
    /// - Warning:
    /// If `unsafeObservable` sends multiple values synchronously,
    /// the last value will be treated as initial value of `Property`.
    public convenience init(unsafeObservable: Observable<E>) {
        let observable = unsafeObservable.share(replay: 1, scope: .whileConnected)
        var initial: E? = nil

        let initialDisposable = observable
            .subscribe(onNext: { initial = $0 })

        guard let initial_ = initial else {
            fatalError("An unsafeObservable promised to send at least one value. Received none.")
        }

        self.init(initial: initial_, then: observable)

        initialDisposable.dispose()
    }

    /// Initializes with `initial` element and then `observable`.
    public init(initial: E, then observable: Observable<E>) {
        _behaviorRelay = BehaviorRelay(value: initial)

        _ = observable
            .bind(to: _behaviorRelay)
            // .disposed(by: disposeBag)    // Comment-Out: Don't dispose when `property` is deallocated
    }

    /// Observable that synchronously sends current element and then changed elements.
    /// This is same as `ReactiveSwift.Property<T>.producer`.
    public func asObservable() -> Observable<E> {
        return _behaviorRelay.asObservable()
    }

    /// Observable that only sends changed elements, ignoring current element.
    /// This is same as `ReactiveSwift.Property<T>.signal`.
    public var changed: Observable<E> {
        return asObservable().skip(1)
    }

}
