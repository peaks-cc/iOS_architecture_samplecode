import UIKit
import RxSwift
import Redux

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - HasWeakStateDisposeBag
//////////////////////////////////////////////////////////////////////////////////////////
protocol HasWeakStateDisposeBag {
    var weakStateDisposeBag: RxSwift.DisposeBag? { get }
}

extension HasWeakStateDisposeBag {
    var disposeBag: RxSwift.DisposeBag {
        return weakStateDisposeBag ?? { assertionFailureUnreachable(); return DisposeBag() }()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - OncePerChild
//////////////////////////////////////////////////////////////////////////////////////////
protocol ShouldAddOnce {
    func checkAdded(to parent: UIViewController) -> Bool
}

extension ShouldAddOnce where Self: UIViewController {
    func checkAdded(to parent: UIViewController) -> Bool {
        return parent.children.filter({ $0 is Self }).count > 0
    }
}
