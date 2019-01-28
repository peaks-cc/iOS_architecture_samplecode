import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
}
