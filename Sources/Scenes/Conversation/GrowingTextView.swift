//
//  GrowingTextView.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 8.11.2021.
//

import UIKit

// swiftlint:disable all
@objc protocol GrowingTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

@objc class GrowingTextView: UITextView {
    override var text: String! {
        didSet { setNeedsDisplay() }
    }
    
    private var heightConstraint: NSLayoutConstraint?
    
    // Maximum length of text. 0 means no limit.
    var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Customization
    var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    
    var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    
    var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    
    var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    private func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    heightConstraint = constraint;
                }
            }
        }
    }
    
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private var shouldScrollAfterHeightChanged = false
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        // Add height constraint if it is not found
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: height
            )
            addConstraint(heightConstraint!)
        }
        
        // Update height constraint if needed
        if height != heightConstraint!.constant {
            shouldScrollAfterHeightChanged = true
            heightConstraint!.constant = height
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight?(self, height: height)
            }
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }
    
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }
    
    // Show placeholder if needed
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else if let placeholder = Desk360.properties?.writeSomethingCountText {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                setNeedsDisplay()
            }
            scrollToCorrectPosition()
        }
    }
    
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            setNeedsDisplay()
        }
    }
}

extension UIView {
    static func vStack(
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        margins: UIEdgeInsets? = nil,
        _ views: [UIView]
    ) -> UIStackView {
        makeStackView(
            axis: .vertical,
            alignment: alignment,
            distribution: distribution,
            spacing: spacing,
            margins: margins,
            views
        )
    }

    static func hStack(
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        margins: UIEdgeInsets? = nil,
        _ views: [UIView]
    ) -> UIStackView {
        makeStackView(
            axis: .horizontal,
            alignment: alignment,
            distribution: distribution,
            spacing: spacing,
            margins: margins,
            views
        )
    }
}

extension UIView {
    static func spacer(length: CGFloat) -> UIView {
        Spacer(length: length, isFixed: true)
    }

    static func spacer(minLength: CGFloat = 0) -> UIView {
        Spacer(length: minLength, isFixed: false)
    }
}

// MARK: - Private
private extension UIView {
    static func makeStackView(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat,
        margins: UIEdgeInsets?,
        _ views: [UIView]
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        if let margins = margins {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = margins
        }
        return stack
    }
}

private final class Spacer: UIView {
    private let length: CGFloat
    private let isFixed: Bool
    private var axis: NSLayoutConstraint.Axis?
    private var observer: AnyObject?
    private var _constraints: [NSLayoutConstraint] = []

    init(length: CGFloat, isFixed: Bool) {
        self.length = length
        self.isFixed = isFixed
        super.init(frame: .zero)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        guard let stackView = newSuperview as? UIStackView else {
            axis = nil
            setNeedsUpdateConstraints()
            return
        }

        axis = stackView.axis
        observer = stackView.observe(\.axis, options: [.initial, .new]) { [weak self] _, axis in
            self?.axis = axis.newValue
            self?.setNeedsUpdateConstraints()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate override func updateConstraints() {
        super.updateConstraints()

        _constraints.removeAll()

        let attributes: [NSLayoutConstraint.Attribute]
        switch axis {
        case .horizontal:
            attributes = [.width]
        case .vertical:
            attributes = [.height]
        default:
            attributes = [.height, .width] // Not really an expected use-case
        }
        _constraints = attributes.map {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: $0,
                relatedBy: isFixed ? .equal : .greaterThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: length
            )
            constraint.priority = UILayoutPriority(999)
            return constraint
        }
        NSLayoutConstraint.activate(_constraints)
    }
}

// swiftlint:disable identifier_name
extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    init(v: CGFloat, h: CGFloat) {
        self = UIEdgeInsets(top: v, left: h, bottom: v, right: h)
    }
}

extension UIView {
    @discardableResult func border(_ color: UIColor, width: CGFloat) -> UIView {
//        layer.borderColor = color.cgColor
//        layer.borderWidth = width
        return self
    }

    func pinToSuperviewEdges(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: padding.left),
            topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.top),
            rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -padding.bottom)
        ])
    }

    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor),
            leftAnchor.constraint(greaterThanOrEqualTo: superview!.leftAnchor),
            rightAnchor.constraint(lessThanOrEqualTo: superview!.rightAnchor)
        ])
    }

    func pinSize(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}
// swiftlint:enable all
