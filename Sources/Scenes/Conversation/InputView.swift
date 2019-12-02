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
	func inputView(_ view: InputView, didTapCreateRequestButton button: UIButton)
	
}

final class InputView: UIView, Layoutable {
	
	weak var delegate: InputViewDelegate?
	
	lazy var textView: UITextView = {
		var view = UITextView()
		view.setContentCompressionResistancePriority(.required, for: .vertical)
		view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		view.textColor = Desk360.Config.currentTheme.conversationInputTextColor
		view.tintColor = Desk360.Config.currentTheme.conversationInputTextColor
		view.font = UIFont.systemFont(ofSize: 18)
		view.clipsToBounds = true
		view.textContainerInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
		return view
	}()
	
	private lazy var buttonBar: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var placeholderLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18)
		label.text = Desk360.Strings.Support.conversationMessageTextViewPlaceholder
		label.textColor = Desk360.Config.currentTheme.requestPlaceholderTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var sendButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = Desk360.Config.currentTheme.backgroundColor
		button.tintColor = Desk360.Config.currentTheme.conversationSendButtonTintColor
		button.setImage(Desk360.Config.Conversation.Input.SendButton.icon, for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		button.titleLabel?.font = Desk360.Config.Conversation.Input.SendButton.font
		button.setContentCompressionResistancePriority(.required, for: .horizontal)
		button.setContentHuggingPriority(.defaultLow, for: .horizontal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.color = Desk360.Config.currentTheme.conversationSendButtonTintColor
		return view
	}()
	
	lazy var createRequestButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = Desk360.Config.currentTheme.requestSendButtonBackgroundColor
		button.tintColor = Desk360.Config.currentTheme.requestTintColor
//		button.setTitle(Desk360.Strings.Support.conversationExpiredButtonTitle, for: .normal)
		button.titleLabel?.font = Desk360.Config.Conversation.Input.CreateRequestButton.font
		button.setTitleColor(Desk360.Config.currentTheme.requestSendButtonTintColor, for: .normal)
		button.layer.cornerRadius = Desk360.Config.Conversation.Input.CreateRequestButton.cornerRadius
		button.clipsToBounds = true
		button.layer.borderWidth = 1
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		return button
	}()
	
	@discardableResult
	override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		return textView.resignFirstResponder()
	}
	
	override func didMoveToWindow() {
		super.didMoveToWindow()
		
		if #available(iOS 11.0, *) {
			guard let aWindow = window else { return }
			bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: aWindow.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
		}
	}
	
	func setupViews() {
		frame = initialFrame
		backgroundColor = Desk360.Config.currentTheme.requestBackgroundColor
		
		textView.addSubview(placeholderLabel)
		textView.delegate = self
		addSubview(textView)
		
		sendButton.isEnabled = false
		sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
		createRequestButton.addTarget(self, action: #selector(didTapCreateRequestButton(_:)), for: .touchUpInside)
		addSubview(sendButton)
		addSubview(activityIndicator)
		addSubview(buttonBar)
		
		addSubview(createRequestButton)
	}
	
	func setupLayout() {
		placeholderLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(textView.textContainerInset.top)
			make.leading.equalToSuperview().inset(textView.textContainerInset.left)
		}
		
		textView.snp.makeConstraints { make in
			make.leading.top.equalToSuperview().inset(preferredSpacing / 2)
			make.bottom.equalToSuperview().inset(preferredSpacing / 2).priority(.low)
		}
		
		buttonBar.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(textView.textContainerInset.bottom).offset(-preferredSpacing * 0.5)
			make.leading.equalToSuperview().inset(textView.textContainerInset.left)
			make.trailing.equalTo(sendButton.snp.leading).offset(-preferredSpacing * 0.25)
			make.height.equalTo(1)
		}
		
		sendButton.snp.makeConstraints { make in
			make.leading.equalTo(textView.snp.trailing).offset(preferredSpacing / 2)
			make.trailing.equalToSuperview().inset(preferredSpacing / 2)
			make.width.lessThanOrEqualToSuperview().multipliedBy(0.20)
			make.bottom.equalTo(textView)
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
	
	func reset() {
		setLoading(false)
		
		textView.text = ""
		
		frame = initialFrame
		textView.isScrollEnabled = false
		placeholderLabel.isHidden = false
		sendButton.isEnabled = false
		translatesAutoresizingMaskIntoConstraints = false
		invalidateIntrinsicContentSize()
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
		placeholderLabel.isHidden = true
		buttonBar.backgroundColor = self.textView.trimmedText != nil ? Colors.ticketDetailWriteMessageBorderActiveColor : Colors.ticketDetailWriteMessageBorderColor
	}
	
	func textViewDidChange(_ textView: UITextView) {
		setSendButton()
		setPlaceholderLabel()
		
		textView.isScrollEnabled = false
		
		let width = textView.frame.size.width
		var height = CGFloat.greatestFiniteMagnitude
		let size = textView.sizeThatFits(.init(width: width, height: height))
		height = size.height + preferredSpacing
		height = max(height, Desk360.Config.Conversation.Input.height)
		
		textView.isScrollEnabled = height > Desk360.Config.Conversation.Input.maxHeight
		guard height <= Desk360.Config.Conversation.Input.maxHeight else { return }
		
		frame.size.height = height
		translatesAutoresizingMaskIntoConstraints = true
		invalidateIntrinsicContentSize()
		layoutIfNeeded()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		placeholderLabel.isHidden = self.textView.trimmedText != nil
		buttonBar.backgroundColor = self.textView.trimmedText != nil ? Colors.ticketDetailWriteMessageBorderActiveColor : Colors.ticketDetailWriteMessageBorderColor
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
	func didTapCreateRequestButton(_ button: UIButton) {
		delegate?.inputView(self, didTapCreateRequestButton: button)
	}
	
}

// MARK: - Configure
internal extension InputView {
	
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
	
	func configureButton() {
		var type = Config.shared.model.ticketDetail?.buttonStyleId
		createRequestButton.layer.shadowColor = UIColor.clear.cgColor
		createRequestButton.setImage(UIImage(), for: .normal)
		let imageIshidden = Config.shared.model.ticketDetail?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model.ticketDetail?.buttonShadowIsHidden ?? true

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
			createRequestButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
			createRequestButton.imageView?.tintColor = Colors.ticketDetailButtonTextColor
		}
		
		if buttonShadowIsHidden {
			createRequestButton.layer.shadowColor = UIColor.black.cgColor
			createRequestButton.layer.shadowOffset = CGSize.zero
			createRequestButton.layer.shadowRadius = 10
			createRequestButton.layer.shadowOpacity = 0.3
			createRequestButton.layer.masksToBounds = false
		}
		
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
		
		sendButton.imageView?.tintColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
		sendButton.backgroundColor = .clear
		
		textView.textColor = Colors.ticketDetailWriteMessageTextColor
		textView.backgroundColor = Colors.ticketDetailChatWriteMessageBackgroundColor
		
		
		createRequestButton.backgroundColor = Colors.ticketDetailButtonBackgroundColor
		createRequestButton.layer.borderColor = Colors.ticketDetailButtonBorderColor.cgColor
		createRequestButton.setTitleColor(Colors.ticketDetailButtonTextColor, for: .normal)
		createRequestButton.setTitle(Config.shared.model.ticketDetail?.buttonText, for: .normal)
		createRequestButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.ticketDetail?.buttonTextFontSize ?? 18), weight: Font.weight(type: Config.shared.model.ticketDetail?.buttonTextFontWeight ?? 400))
		
		configureButton()
		
		buttonBar.backgroundColor = Colors.ticketDetailWriteMessageBorderColor
		setPlaceholderLabel()
	}
	
}

// MARK: - Helpers
private extension InputView {
	
	func setPlaceholderLabel() {
		placeholderLabel.isHidden = textView.trimmedText != nil || textView.isFirstResponder
		buttonBar.backgroundColor = textView.trimmedText != nil || textView.isFirstResponder ? Colors.ticketDetailWriteMessageBorderActiveColor : Colors.ticketDetailWriteMessageBorderColor
	}
	
	func setSendButton() {
		sendButton.isEnabled = textView.trimmedText != nil

		if sendButton.isEnabled {
			sendButton.imageView?.tintColor = Colors.ticketDetailWriteMessageButtonIconColor
		} else {
			sendButton.imageView?.tintColor = Colors.ticketDetailWriteMessageButtonIconDisableColor
		}

		sendButton.alpha = 1

	}
	
	var initialFrame: CGRect {
		return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Desk360.Config.Conversation.Input.height)
	}
	
}
