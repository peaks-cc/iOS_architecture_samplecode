import UIKit
import RxSwift

class NetworkErrorCell: UICollectionViewCell {
    var disposeBag: RxSwift.DisposeBag = .init()

    @IBOutlet weak var retryButton: UIButton!

    struct Metric {
        static let Height: CGFloat = 120
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
}
