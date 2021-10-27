//
//  InputView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import NVActivityIndicatorView

protocol InputViewDelegate: AnyObject {

	func inputView(_ view: InputView, didTapSendButton button: UIButton, withText text: String)
    func inputView(_ view: InputView, didTapAttachButton button: UIButton)
	func inputView(_ view: InputView, didTapCreateRequestButton button: UIButton)
}

class InputView: UIView, Layoutable {
    weak var delegate: InputViewDelegate?

    private var hasAttachView: Bool = false
    private var defaultHeight: CGFloat = 75
    
    lazy var textView: GrowingTextView = {
        var view = GrowingTextView()
        view.minHeight = 35
        view.maxHeight = 50
        view.placeholderColor = Colors.writeMessagePHTextColor ?? .lightGray
        view.placeholder = Config.shared.model?.ticketDetail?.writeMessagePlaceHolderText
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.textContainerInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        view.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
        return view
    }()

    lazy var attachmentView: RemovableAttachmentView = {
        let view = RemovableAttachmentView()
        return view
    }()

    lazy var buttonBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Desk360.Config.Images.sendIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var attachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Desk360.Config.Images.attachIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    lazy var createRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()

//    @discardableResult
//    override func resignFirstResponder() -> Bool {
//        super.resignFirstResponder()
//        return textView.resignFirstResponder()
//    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 96
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        textView.delegate = self
        addSubview(attachmentView)
        addSubview(textView)
        
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        attachButton.addTarget(self, action: #selector(didTapAttachButton(_:)), for: .touchUpInside)
        createRequestButton.addTarget(self, action: #selector(didTapCreateRequestButton(_:)), for: .touchUpInside)
        attachButton.isHidden = !(Config.shared.model?.createScreen?.addedFileIsHidden ?? false)
        addSubview(sendButton)
        addSubview(attachButton)
        addSubview(activityIndicator)
        addSubview(buttonBar)

        addSubview(createRequestButton)
    }
    
    func setupLayout() {
        attachButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalTo(sendButton)
            make.leading.equalTo(12)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(preferredSpacing * 0.5).priority(.required)
            make.leading.equalTo(attachButton.snp.trailing).inset(-4)
            make.bottom.equalTo(attachmentView.snp.top)//.inset(-4).priority(.required)
        }
        
        attachmentView.snp.makeConstraints { make in
          //  make.top.equalTo(textView.snp.bottom)
            make.bottom.equalTo(buttonBar.snp.top).offset(-2)
            make.leading.equalTo(attachButton.snp.trailing).inset(-4)
            make.trailing.equalTo(textView.snp.trailing)
        }
        
        buttonBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(textView.textContainerInset.left)
            make.trailing.equalTo(sendButton.snp.leading).offset(-preferredSpacing * 0.25)
            make.height.equalTo(1)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(textView.snp.trailing).offset(preferredSpacing / 2)
            make.trailing.equalToSuperview().inset(preferredSpacing / 2)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.20)
            make.centerY.equalToSuperview().priority(999)
            make.bottom.equalToSuperview().inset(preferredSpacing / 2)
            make.width.greaterThanOrEqualTo(preferredSpacing * 2)
            make.height.equalTo(Desk360.Config.Conversation.Input.height - (preferredSpacing))
        }
        
        activityIndicator.snp.makeConstraints { $0.center.equalTo(sendButton) }
        
        createRequestButton.snp.makeConstraints { make in
            make.height.equalTo(UIButton.preferredHeight * 1.25)
            make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
            make.top.centerX.equalToSuperview()
        }
    }
    
    
    func reset(isClearText: Bool = true) {
        self.invalidateIntrinsicContentSize()
        DispatchQueue.main.async {
            // self.setLoading(false)
            if isClearText {
                self.textView.text = ""
            }
            //     self.frame = self.initialFrame
            self.textView.isScrollEnabled = false
            
            self.sendButton.isEnabled = false
            self.layoutIfNeeded()
            self.attachmentView.clear()
        }
    }
    
    func resetAttachView() {
        reset(isClearText: false)
        self.hasAttachView = false
    }
}

// MARK: - Loadingable
extension InputView: Loadingable {

    func setLoading(_ loading: Bool) {
        if loading {
            textView.resignFirstResponder()
        }

        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        sendButton.isHidden = loading
        textView.isUserInteractionEnabled = !loading
        setSendButton()
    }
}


// MARK: - UITextViewDelegate
extension InputView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        buttonBar.backgroundColor = self.textView.trimmedText != nil ? Colors.ticketDetailWriteMessageBorderActiveColor : Colors.ticketDetailWriteMessageBorderColor
    }

    func textViewDidChange(_ textView: UITextView) {
        setSendButton()
//        textView.isScrollEnabled = false
//
//        let width = textView.frame.size.width
//        var height = CGFloat.greatestFiniteMagnitude
//        let size = textView.sizeThatFits(.init(width: width, height: height))
//        height = size.height //+ preferredSpacing
//        height = max(height, Desk360.Config.Conversation.Input.height)
//
//        textView.isScrollEnabled = height > Desk360.Config.Conversation.Input.maxHeight
//        if height > Desk360.Config.Conversation.Input.maxHeight {
//            height = Desk360.Config.Conversation.Input.maxHeight
//        }
//        if hasAttachView {
//            height = height + attachmentView.frame.size.height
//        }
//        frame.size.height = height
//        translatesAutoresizingMaskIntoConstraints = true
//        invalidateIntrinsicContentSize()
//        layoutIfNeeded()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        buttonBar.backgroundColor = self.textView.trimmedText != nil ? Colors.ticketDetailWriteMessageBorderActiveColor : Colors.ticketDetailWriteMessageBorderColor
    }

    func configure(for request: Ticket) {
        buttonBar.isHidden = request.status == .expired
        createRequestButton.isHidden = request.status != .expired
        textView.isHidden = request.status == .expired
        sendButton.isHidden = request.status == .expired
        
        if request.status == .expired {
            self.backgroundColor = Colors.ticketDetailChatBackgroundColor
        } else {
            self.backgroundColor = Colors.ticketDetailChatWriteMessageBackgroundColor
        }
        
        if sendButton.isEnabled {
            sendButton.imageView?.tintColor = Colors.ticketDetailWriteMessageButtonIconColor
        } else {
            sendButton.imageView?.tintColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
        }
        sendButton.backgroundColor = .clear
        
        textView.textColor = Colors.ticketDetailWriteMessageTextColor
        textView.tintColor = Colors.ticketDetailWriteMessageTextColor
        let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.ticketDetail?.writeMessageFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.ticketDetail?.writeMessageFontWeight ?? 400))
        textView.font = font
        textView.backgroundColor = Colors.ticketDetailChatWriteMessageBackgroundColor
        createRequestButton.backgroundColor = Colors.firstScreenButtonBackgroundColor
        createRequestButton.layer.borderColor = Colors.firstScreenButttonBorderColor.cgColor
        createRequestButton.setTitleColor(Colors.firstScreenButtonTextColor, for: .normal)
        createRequestButton.setTitle(Config.shared.model?.firstScreen?.buttonText, for: .normal)
        createRequestButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.firstScreen?.buttonTextFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.firstScreen?.buttonTextFontWeight ?? 400))
        
        configureButton()
        buttonBar.backgroundColor = Colors.ticketDetailWriteMessageBorderColor
    }
    
}

// MARK: - Actions
private extension InputView {

    @objc
    func didTapSendButton(_ button: UIButton) {
        guard let text = textView.trimmedText else { return }
        delegate?.inputView(self, didTapSendButton: button, withText: text)
    }

    @objc
    func didTapAttachButton(_ button: UIButton) {
       delegate?.inputView(self, didTapAttachButton: button)
    }

    @objc
    func didTapCreateRequestButton(_ button: UIButton) {
        delegate?.inputView(self, didTapCreateRequestButton: button)
    }
    
    func setSendButton() {
        sendButton.isEnabled = textView.trimmedText != nil
        
        let activeColor = Colors.ticketDetailWriteMessageButtonIconColor
        let passiveColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
        
        sendButton.imageView?.tintColor = sendButton.isEnabled ? activeColor : passiveColor
        
    }
    
    func configureButton() {
        let type = Config.shared.model?.firstScreen?.buttonStyleId
        createRequestButton.layer.shadowColor = UIColor.clear.cgColor
        createRequestButton.setImage(UIImage(), for: .normal)
        let imageIshidden = Config.shared.model?.firstScreen?.buttonIconIsHidden ?? true
        let buttonShadowIsHidden = Config.shared.model?.firstScreen?.buttonShadowIsHidden ?? true
        
        switch type {
        case 1:
            createButtonType1()
        case 2:
            createButtonType2()
        case 3:
            createButtonType3()
        case 4:
            createButtonType4()
        default:
            createButtonType1()
        }
        
        if imageIshidden {
            createRequestButton.setImage(Desk360.Config.Images.unreadIcon, for: .normal)
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                createRequestButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            } else {
                createRequestButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            }
            createRequestButton.imageView?.tintColor = Colors.firstScreenButtonTextColor
        }
        
        if buttonShadowIsHidden {
            createRequestButton.layer.shadowColor = UIColor.black.cgColor
            createRequestButton.layer.shadowOffset = CGSize.zero
            createRequestButton.layer.shadowRadius = 10
            createRequestButton.layer.shadowOpacity = 0.3
            createRequestButton.layer.masksToBounds = false
        }
        
    }
    
    func createButtonType1() {
        createRequestButton.layer.cornerRadius = 22
        setupButtonDefaultLayout()
    }
    
    func createButtonType2() {
        createRequestButton.layer.cornerRadius = 10
        setupButtonDefaultLayout()
    }
    
    func createButtonType3() {
        createRequestButton.layer.cornerRadius = 2
        setupButtonDefaultLayout()
    }
    
    func createButtonType4() {
        
        createRequestButton.layer.cornerRadius = 0
        
        createRequestButton.snp.remakeConstraints { make in
            make.height.equalTo(UIButton.preferredHeight * 1.25)
            make.width.equalTo(UIScreen.main.bounds.size.minDimension + 2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupButtonDefaultLayout() {
        createRequestButton.snp.remakeConstraints { make in
            make.height.equalTo(UIButton.preferredHeight * 1.25)
            make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
            make.top.centerX.equalToSuperview()
        }
    }
}

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
            } else if let placeholder = placeholder {
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

//swiftlint:enable all


// swiftlint:disable all
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
    /// Makes a fixed space along the axis of the containing stack view.
    static func spacer(length: CGFloat) -> UIView {
        Spacer(length: length, isFixed: true)
    }

    /// Makes a flexible space along the axis of the containing stack view.
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

    func pinToSuperviewEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview!.leftAnchor),
            topAnchor.constraint(equalTo: superview!.topAnchor),
            rightAnchor.constraint(equalTo: superview!.rightAnchor),
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor)
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
