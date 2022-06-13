//
//  InputView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

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
        view.minHeight = 50
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
        
        sendButton.isEnabled = textView.text.condenseNewlines.condenseNewlines.isEmpty == false
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
      
        DispatchQueue.main.async {
           // self.setLoading(false)
            if isClearText {
                self.textView.text = ""
            }
            self.sendButton.isEnabled = false
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
    
    func setSendButton() {
        sendButton.isEnabled = textView.text.condenseNewlines.condenseWhitespacs.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        
        let activeColor = Colors.ticketDetailWriteMessageButtonIconColor
        let passiveColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
        self.sendButton.imageView?.tintColor = self.sendButton.isEnabled ? activeColor : passiveColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.sendButton.imageView?.tintColor == .systemBlue {
                self.sendButton.imageView?.tintColor = self.sendButton.isEnabled ? activeColor : passiveColor
        }
        
    }
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
