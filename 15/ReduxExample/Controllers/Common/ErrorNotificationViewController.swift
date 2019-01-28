import UIKit

final class ErrorNotificationViewController: UIViewController, ShouldAddOnce {
    @IBOutlet weak var titleLabel: UILabel!

    init() {
        super.init(nibName: String(describing: ErrorNotificationViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }

    func show(with message: String) {
        titleLabel.text = message
        self.view.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: {
            self.view.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseIn], animations: {
                self.view.alpha = 0.0
            })
        })
    }
}
