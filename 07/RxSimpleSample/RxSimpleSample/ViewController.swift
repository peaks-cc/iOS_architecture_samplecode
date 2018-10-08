//
//  ViewController.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!

    private lazy var viewModel = ViewModel(
        idTextObservable: idTextField.rx.text.asObservable(),
        passwordTextObservable: passwordTextField.rx.text.asObservable(),
        model: Model()
    )
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.validationText
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

