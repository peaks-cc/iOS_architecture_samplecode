import UIKit

final class EmptyViewController: UIViewController, ShouldAddOnce {

    @IBOutlet weak var emptyLabel: UILabel!

    init() {
        super.init(nibName: String(describing: EmptyViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }
}
