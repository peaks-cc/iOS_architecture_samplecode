import XCTest
import ReSwift
import RxSwift
import RxBlocking
import Mockingjay
import MirrorDiffKit
import GitHubAPI
@testable import ReduxExample
@testable import Redux

// swiftlint:disable force_try
// swiftlint:disable force_cast
class RequestTestsWithBlocking: ReduxTestCase {
    var actions: [ReSwift.Action] = []
    var reduxStore: RxReduxStore!

    override func setUp() {
        super.setUp()
        actions = []
        let spyMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
            return { next in
                return { action in
                    self.actions.append(action)
                    return next(action)
                }
            }
        }
        reduxStore = createTestRxReduxStore(store: createTestReSwiftSrore([spyMiddleware]))
    }

    func testPublicRepositoriesStateActionRequestAsyncCreator() {
        let expect: [GitHubAPI.PublicRepo] = try! fixtureObject("repositories.json").get()
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))

        reduxStore.dispatch(
            PublicRepositoriesState.Action.requestAsyncCreator(
                connectionType: .initialRequest,
                disposeBag: disposeBag
            )
        )

        let thunkAction = actions.last as! ThunkAction
        let blocking = thunkAction.single.toBlocking()
        let action = try! blocking.single() as! Redux.PublicRepositoriesState.Action
        guard case .requestSuccess(let response) = action else { XCTFail("An action is not `.requestSuccess`"); return }
        XCTAssert(expect == response.content, diff(between: expect, and: response.content))
    }
}
