import UIKit
import Redux

class AdvertisingCell: UICollectionViewCell {
    struct Metric {
        static let Height: CGFloat = UIScreen.main.bounds.size.width
    }

    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = UIImage(asset: Asset.project006CoverMedium)
    }
}
