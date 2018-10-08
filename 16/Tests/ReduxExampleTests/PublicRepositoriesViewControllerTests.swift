import XCTest
import ReSwift
import RxSwift
import Mockingjay
@testable import ReduxExample
@testable import Redux
@testable import API

// swiftlint:disable force_cast
class PublicRepositoriesViewControllerTests: SnapshotTestCase {
    // swiftlint:disable line_length
    let descriptionForRepositoryLabel = "**Grit is no longer maintained. Check out libgit2/rugged.** Grit gives you object oriented read/write access to Git repositories via Ruby."
    // swiftlint:eable line_length
    var reduxStore: RxReduxStore!
    var vc: PublicRepositoriesViewController!
    var publicRepositoriesState: PublicRepositoriesState {
        return reduxStore.state.publicRepositoriesState!
    }

    override func setUp() {
        super.setUp()
        reduxStore = nil
        vc = nil
    }

    func testInitializeState() {
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))
        reduxStore = createTestRxReduxStore()
        XCTAssertNil(reduxStore.state.publicRepositoriesState)
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        XCTAssertNotNil(publicRepositoriesState)
    }

    func testDisposeStateAndDeinitVC() {
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))
        let exp = expectation(description: "exp")
        let spyMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
            return { next in
                return { action in
                    if action is DisposeAction {
                        XCTAssertNotNil(getState()?.publicRepositoriesState)
                    }
                    next(action)
                    if action is DisposeAction {
                        XCTAssertNil(getState()?.publicRepositoriesState)
                        exp.fulfill()
                    }
                }
            }
        }
        let spyMiddlewares = createTestMiddleware(append: [spyMiddleware])
        let reSwiftStore = createTestReSwiftSrore(spyMiddlewares)
        reduxStore = createTestRxReduxStore(store: reSwiftStore)
        autoreleasepool {
            let vc = Router.controller(reduxStore, routingPage: .publicRepositories)
            _ = vc.view
            vc.viewWillAppear(false)
            vc.viewDidAppear(false)
        }
        waitForExpectations(timeout: 1)
    }

    func testRequestSuccess() {
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))
        reduxStore = createTestRxReduxStore()
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        waitRunLoop()
        XCTAssertEqual(
            16,
            publicRepositoriesState.dataSourceElements.elements.count
        )
        XCTAssertTrue(vc.collectionView.visibleCells.count > 0)
        XCTAssertTrue(vc.loadingViewController.view.isHidden)
        XCTAssertTrue(vc.networkErrorViewController.view.isHidden)
        XCTAssertTrue(vc.serverErrorViewController.view.isHidden)
        XCTAssertTrue(vc.unknownErrorViewController.view.isHidden)

        let ds = publicRepositoriesState.dataSourceElements
        do { // Check DataSource
            do {
                let e: TitleElement = ds.element(indexAt: 0)
                XCTAssertEqual(
                    "TitleElement-MainViewController",
                    e.identifier.description
                )
                XCTAssertEqual("MainViewController", e.title)
            }
            do {
                let e: TitleElement = ds.element(indexAt: 1)
                XCTAssertEqual(
                    "TitleElement-┗ PublicRepositoriesViewController",
                    e.identifier.description
                )
                XCTAssertEqual(
                    "┗ PublicRepositoriesViewController",
                    e.title
                )
            }
            do {
                let e: NoticeElement = ds.element(indexAt: 2)
                XCTAssertEqual("NoticeElement-1", e.identifier.description)
                XCTAssertTrue(e.title ~= "^\\[\\d{2}\\] お知らせ その１です。$")
                let url = URL(string: "https://apple.com")!
                XCTAssertEqual(
                    Routing.Page.webView(url: url),
                    e.routingPage
                )
            }
            do {
                let e: RepositoryHeaderElement = ds.element(indexAt: 3)
                XCTAssertEqual(
                    "RepositoryHeaderElement",
                    e.identifier.description
                )
                let url = URL(string: "https://github.com")!
                XCTAssertEqual(
                    Routing.Page.webView(url: url),
                    e.routingPage
                )
            }
            do {
                let e: PublicRepositoryElement = ds.element(indexAt: 4)
                XCTAssertEqual(
                    "PublicRepositoryElement-1",
                    e.identifier.description
                )
                XCTAssertEqual(1, e.id)
                XCTAssertEqual("mojombo/grit", e.fullName)
                XCTAssertEqual(
                    descriptionForRepositoryLabel,
                    e.descriptionForRepository
                )
                XCTAssertEqual(false, e.isFavorite)
                XCTAssertEqual(
                    Routing.Page.repository((owner: "mojombo", repo: "grit")),
                    e.routingPage
                )
            }
            // ...
        }
        do { // Check UICollectionViewCell
            do {
                let sc = vc.adapter.sectionController(for: ds.elements[0])!
                let cell = sc.cellForItem(at: 0) as! TitleCell
                XCTAssertEqual(
                    "MainViewController",
                    cell.titleLabel.text
                )
            }
            do {
                let sc = vc.adapter.sectionController(for: ds.elements[1])!
                let cell = sc.cellForItem(at: 0) as! TitleCell
                XCTAssertEqual(
                    "┗ PublicRepositoriesViewController",
                    cell.titleLabel.text
                )
            }
            do {
                let sc = vc.adapter.sectionController(for: ds.elements[2])!
                let cell = sc.cellForItem(at: 0) as! NoticeCell
                XCTAssertTrue(
                    cell.titleLabel.text! ~= "^\\[\\d{2}\\] お知らせ その１です。$"
                )
            }
            do {
                let sc = vc.adapter.sectionController(for: ds.elements[3])!
                let cell = sc.cellForItem(at: 0) as! RepositoryHeaderCell
                XCTAssertEqual(
                    UIImage(asset: Asset.gitHub),
                    cell.imageView.image
                )
            }
            do {
                let sc = vc.adapter.sectionController(for: ds.elements[4])!
                let cell = sc.cellForItem(at: 0) as! PublicRepositoryCell
                XCTAssertEqual(
                    "mojombo/grit",
                    cell.titleLabel.text
                )
                XCTAssertEqual(
                    descriptionForRepositoryLabel,
                    cell.descriptionForRepositoryLabel.text
                )
                XCTAssertFalse(cell.favoriteButton.isSelected)
            }
            // ...
        }
    }

    func testLoading() {
        stub(uri("/repositories"), delay: 1, jsonData(fixtureData("repositories.json")))
        let spyMiddlewares = createTestMiddleware(enableThunkBlocking: false) // Disable blocking
        let reSwiftStore = createTestReSwiftSrore(spyMiddlewares)
        reduxStore = createTestRxReduxStore(store: reSwiftStore)
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        waitRunLoop()
        XCTAssertTrue(publicRepositoriesState.shouldShowLoading)
        XCTAssertFalse(vc.loadingViewController.view.isHidden)
        XCTAssertTrue(vc.networkErrorViewController.view.isHidden)
        XCTAssertTrue(vc.serverErrorViewController.view.isHidden)
        XCTAssertTrue(vc.unknownErrorViewController.view.isHidden)
    }

    func testNetworkError() {
        stub(uri("/repositories"), failureTimedOut)
        reduxStore = createTestRxReduxStore()
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        XCTAssertTrue(vc.networkErrorViewController.view.isHidden)
        waitRunLoop()
        XCTAssertFalse(publicRepositoriesState.shouldShowLoading)
        XCTAssertTrue(publicRepositoriesState.shouldShowNetworkError)
        XCTAssertFalse(vc.networkErrorViewController.view.isHidden)
    }

    func testInternalServerError() {
        stub(uri("/repositories"), http(API.internalServerError))
        reduxStore = createTestRxReduxStore()
        vc = createViewContoller(reduxStore, routingPage: .publicRepositories)
        XCTAssertTrue(vc.serverErrorViewController.view.isHidden)
        waitRunLoop()
        XCTAssertFalse(publicRepositoriesState.shouldShowLoading)
        XCTAssertTrue(publicRepositoriesState.shouldShowServerError)
        XCTAssertFalse(vc.serverErrorViewController.view.isHidden)
    }
}
