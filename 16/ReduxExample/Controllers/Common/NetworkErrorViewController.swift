import UIKit

final class NetworkErrorViewController: UIViewController, ShouldAddOnce {
    @IBOutlet weak var retryButton: UIButton!

    init() {
        super.init(nibName: String(describing: NetworkErrorViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
