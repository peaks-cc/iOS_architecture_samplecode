import UIKit

class TitleCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    struct Metric {
        static let Height: CGFloat = 20
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = UIScreen.main.bounds.size.width
    }
}
