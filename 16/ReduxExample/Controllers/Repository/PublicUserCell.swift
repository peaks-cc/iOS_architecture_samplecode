import UIKit

class PublicUserCell: UICollectionViewCell {
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    struct Metric {
        static let Height: CGFloat = 96
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = UIScreen.main.bounds.size.width
    }
}
