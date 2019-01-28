import XCTest
import RxSwift
import FBSnapshotTestCase
import SwiftyBeaver
import Mockingjay
import Kingfisher
@testable import ReduxExample
@testable import Redux
@testable import API

// swiftlint:disable force_cast
class SnapshotTestCase: FBSnapshotTestCase {
    var disposeBag = RxSwift.DisposeBag()

    func createViewContoller<T: UIViewController>(_ reduxStore: RxReduxStore, routingPage: Routing.Page) -> T {
        let vc = Router.controller(reduxStore, routingPage: routingPage) as! T
        showViewController(vc)
        return vc
    }

    func showViewController(_ viewController: UIViewController) {
        _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)

        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        viewController.view.layoutIfNeeded()
    }

    override func setUp() {
        super.setUp()
        recordMode = ProcessInfo.processInfo.environment["RECORD_MODE"] == "true"

        // Clear RxSwift.DisposeBag
        disposeBag = RxSwift.DisposeBag()

        // Setup Logger
        let console = ConsoleDestination()
        console.minLevel = .debug // just log .verbose .debug .info, .Warning & .error
        console.useNSLog = true
        logger.addDestination(console)

        // Kingfisher disable transition animation
        KingfisherManager.shared.defaultOptions = [.transition(.none)]

        // Catch all for un-matched requests
        let error = NSError(domain: "CatchAllForUnMatchedRequests", code: 0, userInfo: nil)
        stub(everything, failure(error))
    }
}
