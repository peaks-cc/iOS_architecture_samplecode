import UIKit

extension UIView {
    var isShown: Bool {
        set {
            isHidden = (newValue == false)
            if isHidden == false {
                self.superview?.bringSubviewToFront(self)
            }
        }
        get {
            return isHidden == false
        }
    }
}
