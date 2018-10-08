import UIKit
import MarkdownView

class ReadmeCell: UICollectionViewCell {
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var markdownContainerView: UIView!
    let markdownView: MarkdownView = .init()

    struct Metric {
        static let Margin: CGFloat = 10
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = UIScreen.main.bounds.size.width
        markdownView.isScrollEnabled = false
        markdownContainerView.addSubview(markdownView)
        markdownView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markdownView.topAnchor.constraint(equalTo: markdownContainerView.topAnchor, constant: Metric.Margin),
            markdownView.leadingAnchor.constraint(equalTo: markdownContainerView.leadingAnchor),
            markdownView.trailingAnchor.constraint(equalTo: markdownContainerView.trailingAnchor),
            markdownView.bottomAnchor.constraint(equalTo: markdownContainerView.bottomAnchor)
        ])
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
