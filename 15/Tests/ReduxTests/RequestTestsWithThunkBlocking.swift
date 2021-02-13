import XCTest
import ReSwift
import RxSwift
import Mockingjay
import MirrorDiffKit
import GitHubAPI
@testable import Redux
@testable import API

class RequestTestsWithThunkBlocking: ReduxTestCase {
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
        let spyMiddlewares = createTestMiddleware(append: [spyMiddleware])
        let reSwiftStore = createTestReSwiftSrore(spyMiddlewares)
        reduxStore = createTestRxReduxStore(store: reSwiftStore)
    }

    func testPublicRepositoriesStateActionRequestAsyncCreator() {
        let expect: [GitHubAPI.PublicRepo] = try! fixtureObject("repositories.json").get()
        stub(uri("/repositories"), jsonData(fixtureData("repositories.json")))

        // Execute request
        let perPage = 30
        reduxStore.dispatch(
            PublicRepositoriesState.Action.requestAsyncCreator(
                connectionType: .initialRequest,
                disposeBag: disposeBag,
                perPage: perPage
            )
        )

        // Check reponse
        guard
            let action = actions.last as? Redux.PublicRepositoriesState.Action,
            case .requestSuccess(let response) = action else {
                XCTFail("An action is not `.requestSuccess`")
                return
        }
        XCTAssert(expect == response.content, diff(between: expect, and: response.content))

        // Check request
        XCTAssertEqual(
            "https://api.github.com/repositories?per_page=\(perPage)",
            response.urlRequest.url?.absoluteString
        )
        XCTAssertEqual("GET", response.urlRequest.httpMethod)
    }

    func testInternalServerError() {
        stub(uri("/repositories"), http(API.internalServerError))

        // Execute request
        let perPage = 30
        reduxStore.dispatch(
            PublicRepositoriesState.Action.requestAsyncCreator(
                connectionType: .initialRequest,
                disposeBag: disposeBag,
                perPage: perPage
            )
        )

        // Check reponse
        guard
            let action = actions.last as? Redux.PublicRepositoriesState.Action,
            case .requestError(let error) = action else {
                XCTFail("An action is not `.requestError` \(actions)")
                return
        }
        XCTAssertTrue(error.isInternalServerError)
        XCTAssertEqual(API.internalServerError, error.responseError?.statusCode)
    }

    func testNetworkError() {
        [
            NSURLErrorTimedOut,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorCannotConnectToHost,
            NSURLErrorServerCertificateUntrusted
        ].forEach {
            stub(uri("/repositories"), failure(NSError(domain: NSURLErrorDomain, code: $0)))

            // Execute request
            let perPage = 30
            reduxStore.dispatch(
                PublicRepositoriesState.Action.requestAsyncCreator(
                    connectionType: .initialRequest,
                    disposeBag: disposeBag,
                    perPage: perPage
                )
            )

            // Check reponse
            guard
                let action = actions.last as? Redux.PublicRepositoriesState.Action,
                case .requestError(let error) = action else {
                    XCTFail("An action is not `.requestError` \(actions)")
                    return
            }
            XCTAssertTrue(error.isNetworkError)
            XCTAssertEqual($0, error.networkError?.code)
        }
    }
}
