import UIKit

@IBDesignable
class OutlinedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 4
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1)

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

        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        titleLabel?.textColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
