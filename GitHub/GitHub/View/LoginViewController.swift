//
//  LoginViewController.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import WebKit

public protocol LoginViewControllerDelegate: class {
    func loginViewController(_ viewController: LoginViewController, didReceive accessToken: AccessToken)
    func loginViewController(_ viewController: LoginViewController, didReceive error: Error)
}

public final class LoginViewController: UINavigationController {
    private let webViewController: LoginWebViewController

    public weak var loginDelegate: LoginViewControllerDelegate?

    public init(clientID: String,
                clientSecret: String,
                redirectURL: String) {
        self.webViewController = LoginWebViewController(clientID: clientID,
                                                        clientSecret: clientSecret,
                                                        redirectURL: redirectURL)
        super.init(nibName:  nil, bundle: nil)

        webViewController.accessTokenHandler = { [weak self] in
            guard let me = self else {
                return
            }
            self?.loginDelegate?.loginViewController(me, didReceive: $0)
        }

        webViewController.errorHandler = { [weak self] in
            guard let me = self else {
                return
            }
            self?.loginDelegate?.loginViewController(me, didReceive: $0)
        }

        setViewControllers([webViewController], animated: false)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class LoginWebViewController: UIViewController {
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let progressView = UIProgressView(progressViewStyle: .default)

    private let activityIndicatorView: UIActivityIndicatorView = {
        #if swift(>=4.2)
        return UIActivityIndicatorView(style: .whiteLarge)
        #else
        return UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        #endif
    }()
    private lazy var alphaView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isHidden = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: activityIndicatorView.bounds.size.height),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: activityIndicatorView.bounds.size.width)
        ])
        return view
    }()

    private let clientID: String
    private let clientSecret: String
    private let redirectURL: String

    private let session = Session()

    var accessTokenHandler: ((AccessToken) -> ())?
    var errorHandler: ((Error) -> ())?

    private lazy var progressObservation: NSKeyValueObservation = {
        return webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
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

    deinit {
        progressObservation.invalidate()
    }

    init(clientID: String,
         clientSecret: String,
         redirectURL: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([.top, .right, .bottom, .left].map {
            NSLayoutConstraint(item: view!, attribute: $0, relatedBy: .equal, toItem: webView, attribute: $0, multiplier: 1, constant: 0)
        })

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: progressView.topAnchor),
            view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: progressView.leftAnchor),
            view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: progressView.rightAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])

        view.addSubview(alphaView)
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([.top, .right, .bottom, .left].map {
            NSLayoutConstraint(item: view!, attribute: $0, relatedBy: .equal, toItem: alphaView, attribute: $0, multiplier: 1, constant: 0)
        })

        webView.navigationDelegate = self
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURL)&scope=public_repo")!
        webView.load(URLRequest(url: url))

        _ = progressObservation
    }
}

extension LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        redirect: if let url = navigationAction.request.url, url.absoluteString.hasPrefix(redirectURL) {
            guard
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let code = components.queryItems?.first(where: { $0.name == "code" })?.value
            else {
                break redirect
            }

            alphaView.isHidden = false
            activityIndicatorView.startAnimating()
            let request = LoginOauthAccessTokenRequest(clientID: clientID, clientSecret: clientSecret, code: code)
            session.send(request) { [weak self] result in
                DispatchQueue.main.async {
                    self?.alphaView.isHidden = true
                    self?.activityIndicatorView.stopAnimating()
                }
                switch result {
                case let .success((accessToken, _)):
                    self?.accessTokenHandler?(accessToken)
                case let .failure(error):
                    self?.errorHandler?(error)
                }
            }

            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
}
