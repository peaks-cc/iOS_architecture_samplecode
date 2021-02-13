import UIKit
import WebKit
import Redux

final class WebViewController: UIViewController {
    let webView: WKWebView = .init()
    let progressView: UIProgressView = .init(progressViewStyle: .default)
    let reduxStore: RxReduxStore
    let url: URL
    var didSetupConstraints = false

    lazy var progressObservation: NSKeyValueObservation = {
        return webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
            guard let progress = change.newValue else { return }
            UIView.animate(withDuration: 0.3) {
                let isShownn = 0.0..<1.0 ~= progress
                self?.progressView.alpha = isShownn ? 1 : 0
                self?.progressView.setProgress(Float(progress), animated: isShownn)
            }
        }
    }()

    init(reduxStore: RxReduxStore, url: URL) {
        self.reduxStore = reduxStore
        self.url = url
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        _ = progressObservation

        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if didSetupConstraints == false {
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])

            progressView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                progressView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                progressView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                progressView.heightAnchor.constraint(equalToConstant: 2)
            ])
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        logger.error(error)
    }
}
