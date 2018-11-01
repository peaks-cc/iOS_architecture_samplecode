import UIKit
import WebKit

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var repoURL: URL?

    override func viewDidLoad() {
        if let url = repoURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
