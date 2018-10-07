import UIKit

@IBDesignable
class TextButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 4
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .clear
    @IBInspectable var shadowOffset: CGSize = .zero
    @IBInspectable var shadowOpacity: Float = 0

    private let defaultColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()

        if let title = title(for: state) {
            setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key(String(kCTLanguageAttributeName)): "ja"]), for: .normal)
        }
    }

    private func commonInit() {
        isExclusiveTouch = true

        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }

    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        guard currentImage != nil else {
            return bounds
        }
        return bounds.insetBy(dx: 16, dy: 0)
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageRect = super.imageRect(forContentRect: contentRect)
        guard currentImage != nil else {
            return imageRect
        }
        let imageSize = CGSize(width: 24, height: 24)
        imageRect.origin.y = (contentRect.height - imageSize.height) / 2
        imageRect.size = imageSize
        return imageRect
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleRect = super.titleRect(forContentRect: contentRect)
        guard currentImage != nil else {
            return titleRect
        }
        titleRect.origin.x += 16
        return titleRect
    }
}
