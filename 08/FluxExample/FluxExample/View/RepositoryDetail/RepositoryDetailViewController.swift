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

    private lazy var favoriteButton = UIBarButtonItem(title: nil,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(self.favoriteButtonTap(_:)))

    private let selectedStore: SelectedRepositoryStore
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator

    private lazy var repositoryStoreSubscription: Subscription = {
        return favoriteStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.updateFavoriteButton()
            }
        }
    }()

    private lazy var progressObservation: NSKeyValueObservation = {
        return webview.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
            guard let progress = change.newValue else {
                return
            }
            UIView.animate(withDuration: 0.3) {
                let isShown = 0.0..<1.0 ~= progress
                self?.progressView.alpha = isShown ? 1 : 0
                self?.progressView.setProgress(Float(progress), animated: isShown)
            }
        }
    }()

    private var isFavorite: Bool {
        return favoriteStore.repositories.contains {
            $0.id == selectedStore.repository?.id
        }
    }

    deinit {
        actionCreator.setSelectedRepository(nil)
        favoriteStore.removeListener(repositoryStoreSubscription)
        progressObservation.invalidate()
    }

    init(selectedStore: SelectedRepositoryStore = .shared,
         favoriteStore: FavoriteRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.selectedStore = selectedStore
        self.favoriteStore = favoriteStore
        self.actionCreator = actionCreator

        super.init(nibName: "RepositoryDetailViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let repository = selectedStore.repository else {
            return
        }

        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()

        _ = repositoryStoreSubscription
        _ = progressObservation

        webview.load(URLRequest(url: repository.htmlURL))
    }

    private func updateFavoriteButton() {
        favoriteButton.title = isFavorite ? "🌟 Unstar" : "⭐️ Star"
    }

    @objc private func favoriteButtonTap(_ button: UIBarButtonItem) {
        guard let repository = selectedStore.repository else {
            return
        }

        if isFavorite {
            actionCreator.removeFavoriteRepository(repository)
        } else {
            actionCreator.addFavoriteRepository(repository)
        }
    }
}
