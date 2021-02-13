//
//  RepositoryDetailViewController.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import UIKit
import RxCocoa
import RxSwift
import WebKit

final class RepositoryDetailViewController: UIViewController {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webviewContainer: UIView! {
        didSet {
            webview.translatesAutoresizingMaskIntoConstraints = false
            webviewContainer.addSubview(webview)

            let constraints = [.top, .right, .left, .bottom].map {
                NSLayoutConstraint(item: webviewContainer!,
                                   attribute: $0,
                                   relatedBy: .equal,
                                   toItem: webview,
                                   attribute: $0,
                                   multiplier: 1,
                                   constant: 0)
            }
            NSLayoutConstraint.activate(constraints)
        }
    }

    private let configuration = WKWebViewConfiguration()
    private lazy var webview = WKWebView(frame: .zero, configuration: configuration)

    private lazy var favoriteButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

    private let flux: Flux
    private lazy var viewModel = RepositoryDetailViewModel(estimatedProgress: webview.rx.observeWeakly(Double.self, #keyPath(WKWebView.estimatedProgress)),
                                                           favoriteButtonTap: favoriteButton.rx.tap.asObservable(),
                                                           flux: flux)

    private let disposeBag = DisposeBag()

    init(flux: Flux = .shared) {
        self.flux = flux
        
        super.init(nibName: "RepositoryDetailViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = favoriteButton

        viewModel.estimatedProgress
            .bind(to: Binder(self) { me, progress in
                UIView.animate(withDuration: 0.3) {
                    let isShown = 0.0..<1.0 ~= progress
                    me.progressView.alpha = isShown ? 1 : 0
                    me.progressView.setProgress(Float(progress), animated: isShown)
                }
            })
            .disposed(by: disposeBag)

        viewModel.favoriteButtonTitile
            .bind(to: Binder(favoriteButton) { button, title in
                button.title = title
            })
            .disposed(by: disposeBag)

        viewModel.repository
            .bind(to: Binder(webview) { webview, repository in
                webview.load(URLRequest(url: repository.htmlURL))
            })
            .disposed(by: disposeBag)
    }
}

