import UIKit

final class ServerErrorViewController: UIViewController, ShouldAddOnce {
    init() {
        super.init(nibName: String(describing: ServerErrorViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
