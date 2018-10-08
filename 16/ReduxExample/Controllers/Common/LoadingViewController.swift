import UIKit

final class LoadingViewController: UIViewController, ShouldAddOnce {
    init() {
        super.init(nibName: String(describing: LoadingViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
