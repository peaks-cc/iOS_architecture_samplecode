import UIKit
import Mockingjay
import FBSnapshotTestCase
@testable import Redux

func showViewController(_ viewController: UIViewController, height: CGFloat? = nil) {
    let window = UIWindow()
    window.backgroundColor = .white
    window.rootViewController = viewController
    window.makeKeyAndVisible()

    if let height = height {
        window.frame.size.height = height + window.safeAreaInsets.top
    }
    _ = viewController.view
}

extension FBSnapshotTestCase {
    struct VerifyOptions: OptionSet {
        let rawValue: Int
        static let fullscreen = VerifyOptions(rawValue: 1 << 0)
    }

    func verifyViewController(_ viewController: UIViewController, identifier: String = "", options: VerifyOptions = []) {
        let recordModeValue = ProcessInfo.processInfo.environment["RECORD_MODE"]
        let recordMode = recordModeValue == "true"
        print("ProcessInfo Environment RECORD_MODE=\(recordMode) VALUE [\(recordModeValue ?? "nil")]")
        if let view = viewController.view {
            if options.contains(.fullscreen) {
                let conentView: UIView
                if let navigationController = viewController as? UINavigationController,
                    let firstViewController = navigationController.viewControllers.first {
                    conentView = firstViewController.view
                } else {
                    conentView = view
                }

                var subviews = [UIView]()
                for subview in conentView.subviews {
                    subviews.append(subview)
                    for subsubview in subview.subviews {
                        subviews.append(subsubview)
                    }
                }

                for subview in subviews {
                    if let scrollView = subview as? UIScrollView {
                        var contentSize = scrollView.contentSize
                        let adjustedContentInset = scrollView.adjustedContentInset
                        contentSize.width += adjustedContentInset.left + adjustedContentInset.right
                        contentSize.height += adjustedContentInset.top + adjustedContentInset.bottom
                        let contentInset = scrollView.contentInset
                        contentSize.width += contentInset.left + contentInset.right
                        contentSize.height += contentInset.top + contentInset.bottom

                        view.frame.size = contentSize
                        break
                    }
                }
            }
            waitRunLoop(1)

            let modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]!
            let suffixes = NSOrderedSet(array: ["_\(modelIdentifier)_\(UIDevice.current.systemVersion)"])
            FBSnapshotVerifyView(view, identifier: identifier, suffixes: suffixes, perPixelTolerance: 0.05)
        } else {
            XCTFail("Can not find viewController.view")
        }
    }

    func verifyView(_ view: UIView, identifier: String = "") {
        let modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]!
        let suffixes = NSOrderedSet(array: ["_\(modelIdentifier)_\(UIDevice.current.systemVersion)"])
        FBSnapshotVerifyView(view, identifier: identifier, suffixes: suffixes, perPixelTolerance: 0.05)
    }
}

func waitRunLoop(_ secs: TimeInterval = 0.01) {
    RunLoop.main.run(until: Date(timeIntervalSinceNow: secs))
}
