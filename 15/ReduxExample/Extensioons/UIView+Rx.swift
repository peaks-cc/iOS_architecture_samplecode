import UIKit
import RxSwift

extension Reactive where Base: UIView {
    public var isShown: Binder<Bool> {
        return Binder(self.base) { view, show in
            view.isHidden = (show == false)
        }
    }
}
