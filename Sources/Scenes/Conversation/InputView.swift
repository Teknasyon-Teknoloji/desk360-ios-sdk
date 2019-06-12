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
		view.layer.borderColor = Desk360.Config.currentTheme.conversationInputBorderColor.cgColor
		view.font = UIFont.systemFont(ofSize: 18)
		view.layer.cornerRadius = 8
		view.layer.borderWidth = 1
		view.clipsToBounds = true
		view.textContainerInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
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
		button.setTitle(Desk360.Strings.Support.conversationExpiredButtonTitle, for: .normal)
		button.titleLabel?.font = Desk360.Config.Conversation.Input.CreateRequestButton.font
		button.setTitleColor(Desk360.Config.currentTheme.requestSendButtonTintColor, for: .normal)
		button.layer.cornerRadius = Desk360.Config.Conversation.Input.CreateRequestButton.cornerRadius
		button.clipsToBounds = true
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
			make.height.equalTo(UIButton.preferredHeight)
			make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
			make.center.equalToSuperview()
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

	func configure(for request: Ticket) {
		createRequestButton.isHidden = request.status != .expired
		if request.status == .expired {
			textView.isHidden = true
			sendButton.isHidden = true
		}
	}

}

// MARK: - Helpers
private extension InputView {

	func setPlaceholderLabel() {
		placeholderLabel.isHidden = textView.trimmedText != nil || textView.isFirstResponder
	}

	func setSendButton() {
		sendButton.isEnabled = textView.trimmedText != nil
	}

	var initialFrame: CGRect {
		return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Desk360.Config.Conversation.Input.height)
	}

}
