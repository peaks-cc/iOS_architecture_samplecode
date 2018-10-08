import UIKit
import Redux

final class ServiceUnavailableViewController: UIViewController {
    let reduxStore: ReduxStoreType

    init(reduxStore: ReduxStoreType) {
        self.reduxStore = reduxStore
        super.init(nibName: String(describing: ServiceUnavailableViewController.self), bundle: nil)
        initLog()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitLog()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
