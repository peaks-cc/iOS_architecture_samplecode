import UIKit
import RxSwift
import Redux

final class PublicRepositoryCell: UICollectionViewCell {
    var disposeBag: RxSwift.DisposeBag = .init()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionForRepositoryLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    struct Metric {
        static let Height: CGFloat = 96
    }

    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
}
