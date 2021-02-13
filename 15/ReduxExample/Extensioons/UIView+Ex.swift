import UIKit

extension UIView {
    var isShown: Bool {
        get {
            return isHidden == false
        }
        set {
            isHidden = (newValue == false)
            if isHidden == false {
                self.superview?.bringSubviewToFront(self)
            }
        }
    }
}
