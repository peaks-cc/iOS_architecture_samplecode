import Foundation
import RxSwift

extension RxSwift.DisposeBag: Hashable {
    public static func == (lhs: DisposeBag, rhs: DisposeBag) -> Bool {
        return lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        let h = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        hasher.combine("\(h)")
    }
}
