import UIKit

@IBDesignable
class TextField: UITextField {
    @IBInspectable var assistiveText: String = "" {
        didSet {
            updateAssisiveTextLabel()
        }
    }
    @IBInspectable var errorText: String = "" {
        didSet {
            updateAssisiveTextLabel()
        }
    }

    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    override var isSecureTextEntry: Bool {
        didSet {
            if isSecureTextEntry, let text = text {
                insertText(text)
            } else {
                let t = text
                text = nil
                text = t
            }
        }
    }

    let contentView = UIView()
    let underlineView = UIView()

    let labelTextLabel = UILabel()
    let assistiveTextLabel = UILabel()

    var notificationToken: NSObjectProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        if let notificationToken = notificationToken {
            NotificationCenter.default.removeObserver(notificationToken)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func commonInit() {
        setupViews()
        setupLabelTextAnimation()
        updateAssisiveTextLabel()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.y = 20
        return textRect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.y = 20
        return editingRect
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftViewRect = super.leftViewRect(forBounds: bounds)
        leftViewRect.origin.x += 1
        leftViewRect.origin.y = 10
        leftViewRect.size = CGSize(width: 24, height: 24)
        return leftViewRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightViewRect = super.rightViewRect(forBounds: bounds)
        rightViewRect.origin.x -= 1
        rightViewRect.origin.y = 10
        rightViewRect.size = CGSize(width: 24, height: 24)
        return rightViewRect
    }

    private func setupViews() {
        isExclusiveTouch = true

        backgroundColor = .clear
        borderStyle = .none
        contentVerticalAlignment = .top
        updatePlaceholder()

        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 42)])

        underlineView.backgroundColor = UIColor(red: 218/255, green: 219/255, blue: 227/255, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(underlineView)
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 0.5)])

        labelTextLabel.backgroundColor = .clear
        labelTextLabel.text = ""
        labelTextLabel.textColor = UIColor(red: 130/255, green: 130/255, blue: 144/255, alpha: 1)
        labelTextLabel.textAlignment = .left
        labelTextLabel.lineBreakMode = .byTruncatingTail
        labelTextLabel.numberOfLines = 1
        labelTextLabel.font = UIFont.systemFont(ofSize: 12)
        labelTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelTextLabel)
        NSLayoutConstraint.activate([
            labelTextLabel.topAnchor.constraint(equalTo: topAnchor),
            labelTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)])

        assistiveTextLabel.backgroundColor = .clear
        assistiveTextLabel.text = assistiveText
        assistiveTextLabel.textColor = UIColor(red: 130/255, green: 130/255, blue: 144/255, alpha: 1)
        assistiveTextLabel.textAlignment = .left
        assistiveTextLabel.lineBreakMode = .byCharWrapping
        assistiveTextLabel.numberOfLines = 0
        assistiveTextLabel.font = UIFont.systemFont(ofSize: 11)
        assistiveTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(assistiveTextLabel)
        NSLayoutConstraint.activate([
            assistiveTextLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 3),
            assistiveTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            assistiveTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            assistiveTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }

    private func setupLabelTextAnimation() {
        notificationToken = NotificationCenter.default
                                .addObserver(forName: UITextField.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
            guard let labelTextLabel = self?.labelTextLabel else {
                return
            }

            let duration: TimeInterval = 0.2
            if let text = self?.text, !text.isEmpty {
                guard let labelText = labelTextLabel.text, labelText.isEmpty else {
                    return
                }
                labelTextLabel.text = self?.placeholder
                labelTextLabel.setNeedsLayout()
                labelTextLabel.layoutIfNeeded()

                let labelHeight = labelTextLabel.bounds.height
                labelTextLabel.transform = CGAffineTransform(translationX: 0, y: labelHeight)
                labelTextLabel.alpha = 0
                UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                    labelTextLabel.transform = .identity
                    labelTextLabel.alpha = 1
                })
            } else {
                UIView.transition(with: labelTextLabel, duration: duration, options: [.transitionCrossDissolve], animations: {
                    labelTextLabel.text = ""
                })
            }
        }
    }

    private func updatePlaceholder() {
        if let placeholder = placeholder, let font = font {
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                       attributes: [.foregroundColor: UIColor(red: 218/255, green: 219/255, blue: 227/255, alpha: 1), .font: font])
        }
    }

    private func updateAssisiveTextLabel() {
        if errorText.isEmpty {
            let textColor = UIColor(red: 130/255, green: 130/255, blue: 144/255, alpha: 1)
            labelTextLabel.textColor = textColor

            assistiveTextLabel.textColor = textColor
            assistiveTextLabel.text = assistiveText
        } else {
            let textColor = UIColor(red: 242/255, green: 97/255, blue: 97/255, alpha: 1)
            labelTextLabel.textColor = textColor

            assistiveTextLabel.textColor = textColor
            assistiveTextLabel.text = errorText
        }
    }
}
