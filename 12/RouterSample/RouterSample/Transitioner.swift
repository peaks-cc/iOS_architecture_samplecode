//
// Created by Kenji Tanaka on 2018/09/24.
// Copyright (c) 2018 Kenji Tanaka. All rights reserved.
//

import UIKit

protocol Transitioner: class where Self: UIViewController {
    func push(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> ())?)
}

extension Transitioner {
    func push(viewController: UIViewController, animated: Bool) {
        guard let nc = viewController.navigationController else { return }
        nc.pushViewController(viewController, animated: animated)
    }

    func present(viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        present(viewController, animated: animated, completion: completion)
    }
}