import UIKit

final class RootViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
