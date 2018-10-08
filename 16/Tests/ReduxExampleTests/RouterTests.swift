import XCTest
import ReSwift
import RxSwift
import Mockingjay
@testable import ReduxExample
@testable import Redux
@testable import API

class RouterTests: SnapshotTestCase {
    var reduxStore: RxReduxStore!
    var vc: PublicRepositoriesViewController!
    var publicRepositoriesState: PublicRepositoriesState {
        return reduxStore.state.publicRepositoriesState!
    }

    func test() {
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))
        let exp = expectation(description: "exp")
        let expRoutingPage = Routing.Page.webView(url: URL(string: "https://apple.com")!)
        let mockRouter: TestRouter.MockRouterFunction = { (
            _ reduxStore: RxReduxStore,
            _ transitionStyle: Routing.TransitionStyle,
            _ from: UIViewController?,
            _ routingPage: Routing.Page
        ) in
            XCTAssertTrue(self.reduxStore === reduxStore)
            XCTAssertEqual(Routing.TransitionStyle.push, transitionStyle)
            XCTAssertTrue(self.vc === from)
            XCTAssertEqual(expRoutingPage, routingPage)
            exp.fulfill()
        }
        let router = TestRouter(mockRouter: mockRouter)
        reduxStore = createTestRxReduxStore(router: router)
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        waitRunLoop()
        let ds = publicRepositoriesState.dataSourceElements
        let sc = vc.adapter.sectionController(for: ds.elements[2])!
        sc.didSelectItem(at: 0)
        waitForExpectations(timeout: 1)
    }
}
