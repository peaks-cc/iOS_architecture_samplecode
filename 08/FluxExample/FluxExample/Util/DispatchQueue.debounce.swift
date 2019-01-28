//
//  Debounce.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func debounce(delay: DispatchTimeInterval) -> (_ action: @escaping () -> ()) -> () {
        var lastFireTime: DispatchTime = .now()

        return { [weak self, delay] action in
            let deadline: DispatchTime = .now() + delay
            lastFireTime = .now()
            self?.asyncAfter(deadline: deadline) { [delay] in
                let now: DispatchTime = .now()
                let when: DispatchTime = lastFireTime + delay
                if now < when { return }
                lastFireTime = .now()
                action()
            }
        }
    }
}
