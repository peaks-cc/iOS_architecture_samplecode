import UIKit
import Redux

final class RepositoryHeaderCell: UICollectionViewCell {
    struct Metric {
        static let Height: CGFloat = 160
    }

    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = UIImage(asset: Asset.gitHub)
    }
}
