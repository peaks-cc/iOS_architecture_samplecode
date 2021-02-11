//
//  LoginViewController.swift
//  GitHub
//
//  Created by marty-suzuki on 2018/08/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import WebKit
import Redux

final class LoginWebViewController: UIViewController {
    let reduxStore: ReduxStoreType
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let progressView = UIProgressView(progressViewStyle: .default)

    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
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

    private lazy var progressObservation: NSKeyValueObservation = {
        return webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
            guard let progress = change.newValue else {
                return
            }
            UIView.animate(withDuration: 0.3) {
                let isShownn = 0.0..<1.0 ~= progress
                self?.progressView.alpha = isShownn ? 1 : 0
                self?.progressView.setProgress(Float(progress), animated: isShownn)
            }
        }
    }()

    init(reduxStore: ReduxStoreType,
         clientID: String,
         clientSecret: String,
         redirectURL: String) {
        self.reduxStore = reduxStore
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        super.init(nibName: nil, bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        progressObservation.invalidate()
        deinitLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Powered by marty-suzuki"

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

            let url = URL(string: "https://github.com/login/oauth/access_token")!
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            let params = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code
            ]
            req.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            let task = URLSession.shared.dataTask(with: req as URLRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    self?.complete(data: data, response: response, error: error)
                }
            }
            task.resume()

            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func complete(data: Data?, response: URLResponse?, error: Error?) {
        defer {
            activityIndicatorView.stopAnimating()
            dismiss(animated: true, completion: nil)
        }
        if let error = error {
            showErrorAlert(error)
        } else {
            do {
                guard
                    let data = data,
                    let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                    let accessToken = content["access_token"] as? String
                    else {
                        return
                    }
                reduxStore.dispatch(AuthenticationState.Action.keychainSaveAccessTokenCreator(accessToken: accessToken))
            } catch let error {
                showErrorAlert(error)
            }
        }
    }
}
