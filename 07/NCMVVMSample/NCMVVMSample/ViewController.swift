//
//  ViewController.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = ViewModel(
        notificationCenter: notificationCenter)

    override func viewDidLoad() {
        super.viewDidLoad()

        idTextField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)
        passwordTextField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged)

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
    @objc func textFieldEditingChanged(sender: UITextField) {
        viewModel.idPasswordChanged(
            id: idTextField.text,
            password: passwordTextField.text)
    }

    @objc func updateValidationText(notification: Notification) {
        guard let text = notification.object as? String else { return }
        validationLabel.text = text
    }

    @objc func updateValidationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationLabel.textColor = color
    }
}
