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
		view.clipsToBounds = true
		view.textContainerInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
		view.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
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
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
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
			make.centerY.equalToSuperview().priority(.required)
			make.leading.top.equalToSuperview().inset(preferredSpacing * 0.5)
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
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
			make.centerY.equalToSuperview().priority(999)
			make.bottom.equalToSuperview().inset(preferredSpacing / 2)
			make.width.greaterThanOrEqualTo(preferredSpacing * 2)
			make.height.equalTo(Desk360.Config.Conversation.Input.height - (preferredSpacing))
//			make.centerY.equalToSuperview()
		}

		activityIndicator.snp.makeConstraints { $0.center.equalTo(sendButton) }

		createRequestButton.snp.makeConstraints { make in
			make.height.equalTo(UIButton.preferredHeight * 1.25)
			make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
			make.top.centerX.equalToSuperview()
		}
	}

	func reset() {
		DispatchQueue.main.async {
			self.setLoading(false)

			self.textView.text = ""

			self.frame = self.initialFrame
			self.textView.isScrollEnabled = false
			self.placeholderLabel.isHidden = false
			self.sendButton.isEnabled = false
			self.translatesAutoresizingMaskIntoConstraints = false
			self.invalidateIntrinsicContentSize()
		}

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
		let type = Config.shared.model.firstScreen?.buttonStyleId
		createRequestButton.layer.shadowColor = UIColor.clear.cgColor
		createRequestButton.setImage(UIImage(), for: .normal)
		let imageIshidden = Config.shared.model.firstScreen?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model.firstScreen?.buttonShadowIsHidden ?? true

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
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.ticketDetail?.writeMessageFontSize ?? 18), weight: Font.weight(type: Config.shared.model.ticketDetail?.writeMessageFontWeight ?? 400))
		textView.font = font
		textView.backgroundColor = Colors.ticketDetailChatWriteMessageBackgroundColor
		placeholderLabel.text = Config.shared.model.ticketDetail?.writeMessagePlaceHolderText
		placeholderLabel.font = font
		createRequestButton.backgroundColor = Colors.firstScreenButtonBackgroundColor
		createRequestButton.layer.borderColor = Colors.firstScreenButttonBorderColor.cgColor
		createRequestButton.setTitleColor(Colors.firstScreenButtonTextColor, for: .normal)
		createRequestButton.setTitle(Config.shared.model.firstScreen?.buttonText, for: .normal)
		createRequestButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.firstScreen?.buttonTextFontSize ?? 18), weight: Font.weight(type: Config.shared.model.firstScreen?.buttonTextFontWeight ?? 400))

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

		let activeColor = Colors.ticketDetailWriteMessageButtonIconColor
		let passiveColor = Colors.ticketDetailWriteMessageButtonIconDisableColor

		sendButton.imageView?.tintColor = sendButton.isEnabled ? activeColor : passiveColor

	}

	var initialFrame: CGRect {
		return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Desk360.Config.Conversation.Input.height)
	}

}
