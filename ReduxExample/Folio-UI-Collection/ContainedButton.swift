import UIKit

@IBDesignable
class ContainedButton: UIButton {
    @IBInspectable var containerColor: UIColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1) {
        didSet {
            setBackgroundImage(containerColor.image(), for: .normal)
        }
    }
    @IBInspectable var highlightedContainerColor: UIColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 0.9) {
        didSet {
            setBackgroundImage(highlightedContainerColor.image(), for: .highlighted)
        }
    }
    @IBInspectable var selectedContainerColor: UIColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1) {
        didSet {
            setBackgroundImage(selectedContainerColor.image(), for: .selected)
        }
    }
    @IBInspectable var disabledContainerColor: UIColor = UIColor(red: 218/255, green: 219/255, blue: 227/255, alpha: 1) {
        didSet {
            setBackgroundImage(disabledContainerColor.image(), for: .disabled)
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

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
            setAttributedTitle(NSAttributedString(string: title,
                                      attributes: [NSAttributedString.Key(String(kCTLanguageAttributeName)): "ja"]), for: .normal)
        }
    }

    private func commonInit() {
        isExclusiveTouch = true

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        setBackgroundImage(containerColor.image(), for: .normal)
        setBackgroundImage(highlightedContainerColor.image(), for: .highlighted)
        setBackgroundImage(selectedContainerColor.image(), for: .selected)
        setBackgroundImage(disabledContainerColor.image(), for: .disabled)
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
