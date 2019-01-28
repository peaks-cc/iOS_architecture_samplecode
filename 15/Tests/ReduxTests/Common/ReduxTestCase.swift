import XCTest
import RxSwift
import SwiftyBeaver
import Mockingjay

class ReduxTestCase: XCTestCase {
    var disposeBag = RxSwift.DisposeBag()

    override func setUp() {
        super.setUp()
        // Clear RxSwift.DisposeBag
        disposeBag = RxSwift.DisposeBag()

        // Setup Logger
        let console = ConsoleDestination()
        console.minLevel = .debug // just log .verbose .debug .info, .Warning & .error
        console.useNSLog = true
        logger.addDestination(console)

        // Catch all for un-matched requests
        let error = NSError(domain: "CatchAllForUnMatchedRequests", code: 0, userInfo: nil)
        stub(everything, failure(error))
    }
}
