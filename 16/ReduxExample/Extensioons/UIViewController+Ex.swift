import UIKit
import Redux

typealias AutoLayoutClosure = (_ childView: UIView, _ parentView: UIView) -> ()

let defaultAutoLayoutClosure: AutoLayoutClosure = { (_ childView: UIView, _ parentView: UIView) -> () in
    NSLayoutConstraint.activate([
        childView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
        childView.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
        childView.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
        childView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
    ])
}

extension UIViewController {
    func addChildHelper(_ vc: UIViewController, autoLayoutClosure: AutoLayoutClosure = defaultAutoLayoutClosure) {
        if let vc = vc as? ShouldAddOnce, vc.checkAdded(to: self) == true {
            assertionFailureUnreachable()
            return
        }

        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        autoLayoutClosure(vc.view, view)
        vc.didMove(toParent: self)
    }

    func constraintToSafeAreaLayoutGuideAnchorHelper(from childView: UIView, to parentView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            childView.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension UIViewController {
    var errorNotificationViewController: ErrorNotificationViewController {
        if let vc = children.compactMap({ $0 as? ErrorNotificationViewController }).first {
            return vc
        } else {
            let vc = ErrorNotificationViewController()
            addChild(vc)
            view.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                vc.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                vc.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                vc.view.heightAnchor.constraint(equalToConstant: 20)
            ])
            vc.didMove(toParent: self)
            return vc
        }
    }
}
