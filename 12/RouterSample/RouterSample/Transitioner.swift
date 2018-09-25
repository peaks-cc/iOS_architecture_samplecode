//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit

protocol Transitioner: class where Self: UIViewController {
    func push(from: UIViewController, to: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> ())?)
}

extension Transitioner {
    func push(from: UIViewController, to: UIViewController, animated: Bool) {
        guard let nc = from.navigationController else { return }
        nc.pushViewController(to, animated: animated)
    }

    func present(viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        present(viewController, animated: animated, completion: completion)
    }
}