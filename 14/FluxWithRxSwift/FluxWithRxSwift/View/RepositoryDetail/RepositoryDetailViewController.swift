//
//  RepositoryDetailViewController.swift
//  FluxWithRxSwift
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


    private let actionCreator: ActionCreator
    private let favoriteStore: FavoriteRepositoryStore
    private let selectedStore: SelectedRepositoryStore

    private let disposeBag = DisposeBag()

    deinit {
       actionCreator.setSelectedRepository(nil)
    }

    init(actionCreator: ActionCreator = .init(),
         favoriteRepositoryStore: FavoriteRepositoryStore = .shared,
         selectedRepositoryStore: SelectedRepositoryStore = .shared) {
        self.favoriteStore = favoriteRepositoryStore
        self.actionCreator = actionCreator
        self.selectedStore = selectedRepositoryStore

        super.init(nibName: "RepositoryDetailViewController", bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = favoriteButton

        webview.rx.observeWeakly(Double.self, #keyPath(WKWebView.estimatedProgress))
            .flatMap { estimatedProgress -> Observable<Double> in
                estimatedProgress.map(Observable.just) ?? .empty()
            }
            .bind(to: Binder(self) { me, progress in
                UIView.animate(withDuration: 0.3) {
                    let isShown = 0.0..<1.0 ~= progress
                    me.progressView.alpha = isShown ? 1 : 0
                    me.progressView.setProgress(Float(progress), animated: isShown)
                }
            })
            .disposed(by: disposeBag)

        let repository = selectedStore.repositoryObservable
            .flatMap { repository -> Observable<GitHub.Repository> in
                repository.map(Observable.just) ?? .empty()
            }
            .share(replay: 1, scope: .whileConnected)

        let isFavorite = favoriteStore.repositoriesObservable
            .withLatestFrom(repository) { ($0, $1) }
            .map { respositories, repository -> Bool in
                respositories.contains { $0.id == repository.id }
            }
            .share(replay: 1, scope: .whileConnected)

        isFavorite
            .bind(to: Binder(favoriteButton) { button, isFavorite in
                button.title = isFavorite ? "🌟 Unstar" : "⭐️ Star"
            })
            .disposed(by: disposeBag)

        favoriteButton.rx.tap.asObservable()
            .withLatestFrom(isFavorite)
            .withLatestFrom(repository) { ($0, $1) }
            .subscribe(onNext: { [actionCreator] isFavorite, repository in
                if isFavorite {
                    actionCreator.removeFavoriteRepository(repository)
                } else {
                    actionCreator.addFavoriteRepository(repository)
                }
            })
            .disposed(by: disposeBag)

        repository
            .bind(to: Binder(webview) { webview, repository in
                webview.load(URLRequest(url: repository.htmlURL))
            })
            .disposed(by: disposeBag)
    }
}

