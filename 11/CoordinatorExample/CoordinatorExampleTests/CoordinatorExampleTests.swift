import XCTest
@testable import CoordinatorExample

class CoordinatorExampleTests: XCTestCase {

    func testLaunchDeepLink() {
        let userActivity =
            NSUserActivity(activityType:NSUserActivityTypeBrowsingWeb)
        let url = URL(string: "https://example.coordinator.com/123456")!
        userActivity.webpageURL = url

        guard let event = LaunchTracker.Event.create(launchType: .userActivity(userActivity)) else {
            XCTFail()
            return
        }
        XCTAssertEqual(event, .deepLink(url: url))
    }
}
