import UIKit
import RxSwift
import Redux

final class RepositoryCell: UICollectionViewCell {
    var disposeBag: RxSwift.DisposeBag = .init()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionForRepository: UILabel!
    @IBOutlet weak var launguageLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!

    struct Metric {
        static let Height: CGFloat = 120
    }

    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = UIScreen.main.bounds.size.width
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
}
