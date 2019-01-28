import UIKit

final class HighlightView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UICollectionViewCell {
    var highlightView: UIView {
        if let view = subviews.first(where: { $0 is HighlightView }) {
            return view
        } else {
            let view = HighlightView()
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleWidth]
            view.isHidden = true
            view.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
            addSubview(view)
            return view
        }
    }
}
