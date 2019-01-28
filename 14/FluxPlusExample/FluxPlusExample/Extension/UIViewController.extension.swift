//
//  UIViewController.extension.swift
//  FluxWithRxSwift
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController: ExtensionCompatible {}

extension Extension where Base: UIViewController {
    var viewDidAppear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in }
    }

    var viewDidDisappear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map { _ in }
    }
}
