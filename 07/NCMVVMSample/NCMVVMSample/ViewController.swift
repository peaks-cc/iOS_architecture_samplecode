//
//  ViewController.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = ViewModel(notificationCenter: notificationCenter)

    override func viewDidLoad() {
        super.viewDidLoad()

        idTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        // Data Binding
        notificationCenter.addObserver(
            self,
            selector: #selector(updateValidationText),
            name: viewModel.changeText,
            object: nil)

        notificationCenter.addObserver(
            self,
            selector: #selector(updateValidationColor),
            name: viewModel.changeColor,
            object: nil)
    }
}

extension ViewController {
    // MARK: Input
    @objc func textFieldEditingChanged(sender: UITextField) {
        viewModel.idPasswordChanged(id: idTextField.text, password: passwordTextField.text)
    }

    // MARK: Output
    @objc func updateValidationText(notification: Notification) {
        guard let text = notification.object as? String else { return }
        validationLabel.text = text
    }

    @objc func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationLabel.textColor = color
    }
}
