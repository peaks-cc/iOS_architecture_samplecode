//
//  RepositoryDetailViewController.swift
//  FluxExample
//
//  Created by marty-suzuki on 2018/07/31.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import WebKit

final class RepositoryDetailViewController: UIViewController {

    @IBOutlet private weak var webviewContainer: UIView! {
        didSet {
            webview.translatesAutoresizingMaskIntoConstraints = false
            webviewContainer.addSubview(webview)
            
            let constraints = [.top, .right, .left, .bottom].map {
                NSLayoutConstraint(item: webviewContainer,
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

    private let repositoryStore: GithubRepositoryStore
    private let actionCreator: ActionCreator

    deinit {
        actionCreator.setSelectedRepository(nil)
    }

    init(repositoryStore: GithubRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator
        super.init(nibName: "RepositoryDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let repository = repositoryStore.selectedRepository else {
            return
        }

        webview.load(URLRequest(url: repository.htmlURL))
    }
}
