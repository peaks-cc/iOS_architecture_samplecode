import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    public var isShown: RxCocoa.Binder<Bool> {
        return Binder(self.base) { view, show in
            view.isHidden = (show == false)
        }
    }
}
