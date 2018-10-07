import UIKit

class NoticeCell: UICollectionViewCell {
    struct Metric {
        static let Height: CGFloat = 44
    }

    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var angleRightImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        angleRightImageView.image = UIImage(asset: Asset.angleRight)?.withRenderingMode(.alwaysTemplate)
        angleRightImageView.tintColor = .lightGray
    }
}
