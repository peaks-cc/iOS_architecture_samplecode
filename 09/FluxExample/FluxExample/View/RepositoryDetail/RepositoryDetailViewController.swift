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

    private lazy var favoriteButton = UIBarButtonItem(title: nil,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(self.favoriteButtonTap(_:)))

    private let repositoryStore: GithubRepositoryStore
    private let actionCreator: ActionCreator

    private lazy var repositoryStoreSubscription: Subscription = {
        return repositoryStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.updateFavoriteButton()
            }
        }
    }()

    private var isFavorite: Bool {
        return repositoryStore.favorites.contains {
            $0.id == repositoryStore.selectedRepository?.id
        }
    }

    deinit {
        actionCreator.setSelectedRepository(nil)
        repositoryStore.removeListener(repositoryStoreSubscription)
    }

    init(repositoryStore: GithubRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.repositoryStore = repositoryStore
        self.actionCreator = actionCreator

        super.init(nibName: "RepositoryDetailViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let repository = repositoryStore.selectedRepository else {
            return
        }

        navigationItem.rightBarButtonItem = favoriteButton

        updateFavoriteButton()

        _ = repositoryStoreSubscription

        webview.load(URLRequest(url: repository.htmlURL))
    }

    private func updateFavoriteButton() {
        favoriteButton.title = isFavorite ? "🌟 Unstar" : "⭐️ Star"
    }

    @objc private func favoriteButtonTap(_ button: UIBarButtonItem) {
        guard let repository = repositoryStore.selectedRepository else {
            return
        }

        if isFavorite {
            actionCreator.removeFavoriteRepository(repository)
        } else {
            actionCreator.addFavoriteRepository(repository)
        }
    }
}
