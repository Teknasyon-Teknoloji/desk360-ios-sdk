//
//  CreateRequestView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

final class SupportTextField: UITextField {

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 10, dy: 10)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 10, dy: 10)
	}

}

/// Create request view.
final class CreateRequestView: UIView, Layoutable, Loadingable {

	var ticketTypes: [TicketType] = []

	var nameEditCheck = false
	var emailEditCheck = false
	var subjectEditCheck = false

	lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.keyboardDismissMode = .interactive
		return view
	}()

	lazy var nameTextField: SupportTextField = {
		var field = SupportTextField()
		field.setTextType(.generic)
		setFieldStyle(field)

		field.placeholder = Desk360.Strings.Support.createNameTextFieldPlaceholder
		field.setPlaceHolderTextColor(Desk360.Config.currentTheme.requestPlaceholderTextColor)
		field.textColor = Desk360.Config.currentTheme.requestTextColor
		field.tintColor = Desk360.Config.currentTheme.requestTintColor
		field.tag = 1
		return field
	}()

	lazy var nameErrorLabel: UILabel = {
		let label = UILabel()
//		label.textRect(forBounds: CGRect(, limitedToNumberOfLines: <#T##Int#>)
		label.textColor = UIColor.init(hex: "d93a50")!
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .left
		label.text = Desk360.Strings.Support.createNameRegex
		label.isHidden = true
		return label
	}()

	lazy var emailTextField: SupportTextField = {
		var field = SupportTextField()
		field.setTextType(.emailAddress)
		setFieldStyle(field)
		field.tag = 2
		field.placeholder = Desk360.Strings.Support.createEmailTextFieldPlaceholder
		field.setPlaceHolderTextColor(Desk360.Config.currentTheme.requestPlaceholderTextColor)
		field.textColor = Desk360.Config.currentTheme.requestTextColor
		field.tintColor = Desk360.Config.currentTheme.requestTintColor

		return field
	}()

	lazy var emailErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .left
		label.text = Desk360.Strings.Support.createEmailRegex
		label.isHidden = true
		return label
	}()

	lazy var subjectTextField: SupportTextField = {
		var field = SupportTextField()
		field.setTextType(.generic)
		setFieldStyle(field)
		field.tag = 3
		field.placeholder = Desk360.Strings.Support.createSubjectTextFieldPlaceholder
		field.setPlaceHolderTextColor(Desk360.Config.currentTheme.requestPlaceholderTextColor)
		field.textColor = Desk360.Config.currentTheme.requestTextColor
		field.tintColor = Desk360.Config.currentTheme.requestTintColor

		return field
	}()

	lazy var subjectErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .left
		label.text = Desk360.Strings.Support.createSubjectRegex
		label.isHidden = true
		return label
	}()

	lazy var dropDownListView: HADropDown = {
		let view = HADropDown()
		view.title = Desk360.Strings.Support.subjectTypeListPlaceHolder
		view.textAllignment = NSTextAlignment.left
		view.itemTextColor = Desk360.Config.currentTheme.dropDownListTextColor
		view.titleColor = Desk360.Config.currentTheme.requestPlaceholderTextColor
		view.itemBackground = Desk360.Config.currentTheme.dropDownListBackgroundColor
		view.isCollapsed = true
		view.delegate = self

		view.addSubview(arrowIcon)
		return view
	}()

	private lazy var arrowIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = Desk360.Config.currentTheme.arrowIconTintColor
		imageView.image = Desk360.Config.Requests.Create.DropDownListView.arrowIcon
		return imageView
	}()

	lazy var messageTextView: UITextView = {
		var view = UITextView()
		setFieldStyle(view)
		view.backgroundColor = .clear
		view.textColor = Desk360.Config.currentTheme.requestTextColor
		view.tintColor = Desk360.Config.currentTheme.requestTintColor
		view.layer.borderColor = Desk360.Config.currentTheme.requestPlaceholderTextColor.cgColor
		view.layer.borderWidth = Desk360.Config.Requests.Create.MessageTextView.borderWidth
		return view
	}()

	lazy var messageTextViewErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .left
		label.text = Desk360.Strings.Support.createMessageRegex
		label.isHidden = true
		return label
	}()

	lazy var sendButton: UIButton = {
		var button = UIButton(type: .system)
		button.setTitle(Desk360.Strings.Support.createMessageSendButtonTitle, for: .normal)
		button.backgroundColor = Desk360.Config.currentTheme.requestSendButtonBackgroundColor
		button.layer.cornerRadius = Desk360.Config.Requests.Create.SendButton.cornerRadius
		button.clipsToBounds = true
		button.tintColor = Desk360.Config.currentTheme.requestSendButtonTintColor
		button.titleLabel?.font = Desk360.Config.Requests.Create.SendButton.font
		return button
	}()

	private lazy var desk360Label: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.currentTheme.desk360LabelTextColor
		label.text = "Desk360"
		label.font = UIFont.systemFont(ofSize: 12)
		label.textAlignment = .center
		return label
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [nameTextField, nameErrorLabel, emailTextField, emailErrorLabel, subjectTextField, subjectErrorLabel, dropDownListView, messageTextView, messageTextViewErrorLabel])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		view.spacing = preferredSpacing / 2
		return view
	}()

	func setupViews() {
		backgroundColor = Desk360.Config.currentTheme.requestBackgroundColor

		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
		self.addGestureRecognizer(gesture)

		nameTextField.delegate = self
		emailTextField.delegate = self
		messageTextView.delegate = self
		subjectTextField.delegate = self

		nameTextField.addTarget(self, action: #selector(checkTexFields(sender:)), for: .editingChanged)
		emailTextField.addTarget(self, action: #selector(checkTexFields(sender:)), for: .editingChanged)
		subjectTextField.addTarget(self, action: #selector(checkTexFields(sender:)), for: .editingChanged)
		//		dropDownListView.delegate = self

		scrollView.addSubview(stackView)
		scrollView.addSubview(sendButton)
		scrollView.addSubview(desk360Label)
		addSubview(scrollView)

	}

	func setupLayout() {

		nameTextField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight)
		}

		emailTextField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight)
		}

		subjectTextField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight)
		}

		dropDownListView.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight)
			make.width.equalTo(UIScreen.main.bounds.width - preferredSpacing * 6)
		}

		arrowIcon.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(preferredSpacing * 0.5)
			make.centerY.equalToSuperview()
		}

		messageTextView.snp.makeConstraints { make in
			make.height.equalTo(scrollView.snp.height).multipliedBy(0.3)
		}

		sendButton.snp.makeConstraints { make in
			make.top.equalTo(stackView.snp.bottom).offset(preferredSpacing * 1.5)
			make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
			make.width.equalTo(stackView)
			make.bottom.equalTo(desk360Label.snp.top).inset(-preferredSpacing)
		}

		desk360Label.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
		}

		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(preferredSpacing)
			make.width.equalTo(scrollView.snp.width).inset(preferredSpacing)
			make.centerX.equalToSuperview()
		}

		scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

	}

}

// MARK: - Configure
extension CreateRequestView: HADropDownDelegate {
	func willHide(dropDown: HADropDown) { }

	func willShow(dropDown: HADropDown) {
		self.endEditing(true)
	}

	func didHide(dropDown: HADropDown) {
		guard dropDownListView.getSelectedIndex != -1 else {
			dropDownListView.shake()
			return
		}
		messageTextView.becomeFirstResponder()
	}

	func didSelectItem(dropDown: HADropDown, at index: Int) {
		guard index != -1 else { return }
		dropDownListView.titleColor = Desk360.Config.currentTheme.requestTextColor
	}

	func setTicketType(ticketTypes: [TicketType]?) {
		var optionTypes: [String] = []
		guard let ticketTypes = ticketTypes else { return }
		for ticketType in ticketTypes {
			optionTypes.append(ticketType.title)
		}

		dropDownListView.items = optionTypes
	}

}

// MARK: - UITextViewDelegate
extension CreateRequestView: UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
		let offset = CGPoint(x: 0, y: textView.frame.minY)
		scrollView.setContentOffset(offset, animated: true)
	}

	func textViewDidChange(_ textView: UITextView) {
		guard let message = messageTextView.trimmedText, message.count > 0 else { return }
		messageTextViewErrorLabel.isHidden = true
	}

}

// MARK: - Actions
extension CreateRequestView {

	@objc func didTap() {
		self.endEditing(true)
		guard !dropDownListView.isCollapsed else { return }
		dropDownListView.hideList()
	}

}

// MARK: - UITextFieldDelegate
extension CreateRequestView: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case nameTextField:
			guard let text = nameTextField.trimmedText, text.count > 0 else {
				nameErrorLabel.isHidden = false
				nameTextField.shake()
				return false
			}
			nameErrorLabel.isHidden = true
			emailTextField.becomeFirstResponder()
			return true

		case emailTextField:
			if emailTextField.emailAddress == nil {
				emailErrorLabel.isHidden = false
				emailTextField.shake()
				return false
			}
			emailErrorLabel.isHidden = true
			subjectTextField.becomeFirstResponder()
			return true

		case subjectTextField:
			guard let text = subjectTextField.trimmedText, text.count > 0 else {
				subjectTextField.shake()
				subjectErrorLabel.isHidden = false
				return false
			}
			subjectErrorLabel.isHidden = true
			subjectTextField.endEditing(true)
			dropDownListView.showList()
			return true

		case dropDownListView:
			if dropDownListView.getSelectedIndex == -1 {
				dropDownListView.shake()
				dropDownListView.showList()
				return false
			}
			messageTextView.becomeFirstResponder()
			return true

		default:
			return true
		}
	}

}

// MARK: - Actions
extension CreateRequestView {

	@objc func checkTexFields(sender: UITextField) {

		switch sender.tag {
		case 1:
			if let text = nameTextField.trimmedText, text.count > 0 {
				nameErrorLabel.isHidden = true
			}
		case 2:
			if emailTextField.emailAddress != nil {
				emailErrorLabel.isHidden = true
			}
		case 3:
			if let text = subjectTextField.trimmedText, text.count > 0 {
				subjectErrorLabel.isHidden = true
			}
		default:
			break
		}

	}

}

// MARK: - Helpers
private extension CreateRequestView {

	func setFieldStyle(_ field: UIView) {
		field.layer.cornerRadius = Desk360.Config.Requests.Create.cornerRadius
		field.layer.masksToBounds = true
		field.layer.borderWidth = Desk360.Config.Requests.Create.borderWidth
		field.layer.borderColor = Desk360.Config.currentTheme.requestBorderColor.cgColor
		field.tintColor = Desk360.Config.currentTheme.requestTintColor

		let font = Desk360.Config.Requests.Create.font

		if let textField = field as? UITextField {
			textField.font = font
		}

		if let textView = field as? UITextView {
			textView.font = font
			textView.textContainerInset = UIEdgeInsets.init(top: preferredSpacing / 2, left: preferredSpacing / 2, bottom: preferredSpacing / 2, right: preferredSpacing / 2)
		}
	}

}

// MARK: - KeyboardHandling
extension CreateRequestView: KeyboardHandling {

	/// Called right before the keyboard is presented.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardWillShow(_ notification: KeyboardNotification?) {
		let height = notification?.endFrame.size.height ?? 300
		scrollView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
	}

	/// Called right after the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidHide(_ notification: KeyboardNotification?) {
		scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
	}

	/// Called right after the keyboard is presented.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidShow(_ notification: KeyboardNotification?) {}

	/// Called right before the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardWillHide(_ notification: KeyboardNotification?) {}

	/// Called right before the keyboard is about to change its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {}

	/// Called right after the keyboard did changed its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidChangeFrame(_ notification: KeyboardNotification?) {}

}

// MARK: - Helpers
extension CreateRequestView {

	/// Returns width or height, whichever is the smaller value.
	func minDimension(size: CGSize) -> CGFloat {
		return min(size.width, size.height)
	}

}
