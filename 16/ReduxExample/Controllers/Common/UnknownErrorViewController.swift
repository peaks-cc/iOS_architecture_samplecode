import UIKit

final class UnknownErrorViewController: UIViewController, ShouldAddOnce {
    init() {
        super.init(nibName: String(describing: UnknownErrorViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
