//
//  CreateRequestView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

/// Create request view.
// swiftlint:disable file_length
final class CreateRequestView: UIView, Layoutable, Loadingable {

	var ticketTypes: [TicketType] = []
	var fields: [AnyObject] = []

	var fieldType: FieldType = .line

	public override var frame: CGRect {
		willSet { }
		didSet {
			guard self.frame.origin.y < 0 else { return }
			self.frame = oldValue
		}
	}

	var inputFont: UIFont = {
		return UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.formInputFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.createScreen?.formInputFontWeight ?? 400))
	}()

	internal lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.keyboardDismissMode = .interactive
		return view
	}()

	internal lazy var nameTextField: UITextField = {
        var field = SupportTextField(padding: .init(top: 0, left: 10, bottom: 0, right: 50))
		field.setTextType(.generic)
		field.accessibilityIdentifier = "name"
		field.tag = 1
		field.text = (Stores.userName.object != nil) ? Stores.userName.object : ""
		return field
	}()

    internal lazy var nameFieldLimit: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.text = "100/100"
        return label
    }()

	internal lazy var nameErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		configureErrorLabels(label)
		return label
	}()

	internal lazy var emailTextField: UITextField = {
		var field = SupportTextField(padding: .init(top: 0, left: 10, bottom: 0, right: 50))
		field.setTextType(.emailAddress)
		field.tag = 2
		field.accessibilityIdentifier = "email"
		field.text = (Stores.userMail.object != nil) ? Stores.userMail.object : ""

		return field
	}()

    internal lazy var emailFieldLimit: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.text = "100/100"
        return label
    }()

	internal lazy var emailErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		configureErrorLabels(label)
		return label
	}()

	internal lazy var dropDownListView: HADropDown = {
		let view = HADropDown()
		view.accessibilityIdentifier = "type_id"
		view.textAllignment = NSTextAlignment.left
		view.isCollapsed = true
		view.delegate = self
		view.tag = 1
		return view
	}()

	internal lazy var messageTextViewLabel: UILabel = {
		let label = UILabel()
		label.tag = 30
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = preferredSpacing * 0.5
		let text = Config.shared.model?.generalSettings?.messageFieldText ?? ""
		let style = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
		label.attributedText = NSAttributedString(string: text, attributes: style)
		label.baselineAdjustment = .alignBaselines
		configureLabelTextAlignment(label)
		label.isHidden = true
		return label
	}()

	internal lazy var messageTextView: CustomMessageTextView = {
		var view = CustomMessageTextView.create()
		setTextViewStyle(view.messageTextView)
		view.backgroundColor = .clear
		view.messageTextView.accessibilityIdentifier = "message"
		return view
	}()

	lazy var messageTextViewErrorLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hex: "d93a50")!
		configureErrorLabels(label)
		return label
	}()

	private lazy var attachmentContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.addSubview(attachmentButton)
		view.addSubview(attachmentLabel)
		view.addSubview(attachmentCancelButton)
		return view
	}()

	lazy var attachmentButton: UIButton = {
		let button = UIButton()
		button.setImage(Desk360.Config.Images.attachmentIcon, for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: preferredSpacing * 0.5)
		button.titleLabel?.textAlignment = .left
		button.imageView?.contentMode = .scaleAspectFit
		return button
	}()

	lazy var attachmentCancelButton: UIButton = {
		let button = UIButton()
		button.setImage(Desk360.Config.Images.closeIcon, for: .normal)
		button.isHidden = true
		button.isEnabled = false
		button.imageView?.contentMode = .scaleAspectFit
		return button
	}()

	lazy var sendButton: UIButton = {
		var button = UIButton(type: .system)
		button.layer.borderWidth = 1
		button.clipsToBounds = true
		return button
	}()

	private lazy var desk360BottomView: Desk360View = {
		return Desk360View.create()
	}()

	internal lazy var bottomScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.alwaysBounceVertical = true
		return scrollView
	}()

	internal lazy var bottomDescriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

    internal lazy var agreementView: UIView = {
        let view = UIView()
        return view
    }()

    internal lazy var agreementTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.isScrollEnabled = false
        textView.textColor = Colors.createScreenFormInputFocusColor
        return textView
    }()

    internal lazy var agreementButton: UIButton = {
        let button = UIButton()
        button.setImage(Desk360.Config.Images.agreementUnCheckIcon, for: .normal)
        button.setImage(Desk360.Config.Images.agreementCheckIcon, for: .selected)
        return button
    }()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: fields as! [UIView])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		view.spacing = preferredSpacing * 0.5
		return view
	}()

	lazy var attachmentLabel: UILabel = {
		let label = UILabel()
		label.lineBreakMode = .byTruncatingMiddle
		label.textAlignment = .right
		return label
	}()

	func setupViews() {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
		self.addGestureRecognizer(gesture)

		nameTextField.delegate = self
		emailTextField.delegate = self
		messageTextView.messageTextView.delegate = self

		fields.append(nameTextField)
		fields.append(nameErrorLabel)
		fields.append(emailTextField)
		fields.append(emailErrorLabel)
		fields.append(dropDownListView)
		fields.append(messageTextViewLabel)
		fields.append(messageTextView)
		fields.append(messageTextViewErrorLabel)
		fields.append(attachmentContainerView)

		let gesture2 = UITapGestureRecognizer(target: self, action: #selector(endEditingKeyboard))
		messageTextView.addGestureRecognizer(gesture2)

		nameTextField.addTarget(self, action: #selector(checkTexFields(_:)), for: .editingChanged)
		emailTextField.addTarget(self, action: #selector(checkTexFields(_:)), for: .editingChanged)

		scrollView.addSubview(stackView)
		scrollView.addSubview(sendButton)
		addSubview(desk360BottomView)
		addSubview(scrollView)

        scrollView.addSubview(bottomScrollView)

		bottomScrollView.addSubview(bottomDescriptionLabel)

        scrollView.addSubview(agreementView)
        agreementView.addSubview(agreementButton)
        agreementView.addSubview(agreementTextView)

        scrollView.addSubview(nameFieldLimit)
        scrollView.addSubview(emailFieldLimit)
	}

	@objc func endEditingKeyboard() {
		self.endEditing(true)
	}

	// swiftlint:disable function_body_length
	func setupLayout() {
		nameTextField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight * 1.2)
		}
        
		emailTextField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight * 1.2)
		}
        
		dropDownListView.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight * 1.2)
			make.width.equalTo(UIScreen.main.bounds.width - preferredSpacing * 6)
		}

		messageTextViewLabel.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight)
		}

		messageTextView.snp.makeConstraints { make in
			make.height.equalTo(UIButton.preferredHeight * 4)
		}

		sendButton.snp.makeConstraints { make in
            make.top.equalTo(agreementView.snp.bottom).offset(preferredSpacing * 0.4)
            make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
			make.width.equalTo(stackView)
			make.bottom.equalToSuperview().inset(preferredSpacing)
		}

		desk360BottomView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(preferredSpacing * 1.5)
			make.bottom.equalTo(safeArea.bottom)
		}

		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(preferredSpacing)
			make.centerX.equalToSuperview()
			make.width.equalTo(scrollView.snp.width).inset(preferredSpacing)
		}

		scrollView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(desk360BottomView.snp.top) // yeni
		}

		bottomScrollView.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp.bottom).offset((preferredSpacing * 0)) // eski 2.5
            make.height.equalTo(preferredSpacing * 2)
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size))
			make.centerX.equalToSuperview()
		}

		bottomDescriptionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(preferredSpacing * 0.25)
            make.centerX.equalToSuperview()
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
		}

        agreementView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(preferredSpacing * 0.3)
            make.centerX.equalToSuperview()
            make.width.equalTo(sendButton)
            make.height.equalTo(preferredSpacing * 2)
        }

        agreementButton.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }

        agreementTextView.snp.makeConstraints { make in
            make.leading.equalTo(agreementButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalTo(1)
        }

		attachmentButton.snp.makeConstraints { make in
			make.leading.top.bottom.equalToSuperview()
			make.trailing.equalTo(attachmentContainerView.snp.centerX)
		}

		attachmentCancelButton.snp.makeConstraints { make in
			make.top.bottom.trailing.equalToSuperview()
			make.width.equalTo(attachmentCancelButton.snp.height)
		}

		attachmentLabel.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.trailing.equalTo(attachmentCancelButton.snp.leading).offset(-preferredSpacing * 0.1)
			make.leading.equalTo(attachmentButton.snp.trailing).offset(preferredSpacing * 0.1)
		}

	}

}

// MARK: - Add Fields
extension CreateRequestView {

	// swiftlint:disable cyclomatic_complexity
	func addFields() {

		fields.removeAll()

		var fieldModels: [Field] = []
		fieldModels = Config.shared.model?.customFields ?? []

		fields.append(nameTextField)
		fields.append(nameErrorLabel)
		fields.append(emailTextField)
		fields.append(emailErrorLabel)

		for index in 0..<fieldModels.count {
			switch fieldModels[index].type {
			case .input:
				addTextField(fieldModel: fieldModels[index])
			default:
				break
			}
		}

		fields.append(dropDownListView)

		for index in 0..<fieldModels.count {
			switch fieldModels[index].type {
			case .selectbox:
				addDropDownListView(fieldModel: fieldModels[index], index: index)
			default:
				break
			}
		}

		fields.append(messageTextViewLabel)
		fields.append(messageTextView)
		fields.append(messageTextViewErrorLabel)

		for index in 0..<fieldModels.count {
			switch fieldModels[index].type {
			case .textarea:
				addTextView(fieldModel: fieldModels[index])
			default:
				break
			}
		}

		fields.append(attachmentContainerView)

		for view in stackView.arrangedSubviews {
			stackView.removeArrangedSubview(view)
		}
		for view in fields {
			stackView.addArrangedSubview(view as! UIView)
			if view.tag == 30 {
				if #available(iOS 11.0, *) {
					stackView.setCustomSpacing(0, after: view as! UIView)
				}
			}
		}

		if #available(iOS 11.0, *) {
			stackView.setCustomSpacing(0, after: messageTextViewLabel)
		}
	}

	func addTextField(fieldModel: Field) {
		let textField = SupportTextField()

		textField.setTextType(.generic)
		textField.placeholder = fieldModel.placeholder
		textField.tintColor = Colors.createScreenFormInputFocusColor
		setInputFont(textField)
		setFieldStyle(textField)
		// FIXME: Taglemeyi Constant tarafına taşı bir değişkene ata
		textField.tag = 3
		textField.accessibilityIdentifier = fieldModel.name
		textField.delegate = self
		textField.addTarget(self, action: #selector(checkTexFields(_:)), for: .editingChanged)
		fields.append(textField)
		configureField(field: textField)

		textField.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight * 1.2)
		}

		// FIXME: Delete force. make optional
		checkTopLabels(field: textField, text: fieldModel.placeholder ?? "")
		hideTopLabel(textField)
	}

	func addDropDownListView(fieldModel: Field, index: Int) {
		let view = HADropDown()
		view.title = fieldModel.placeholder ?? ""
		view.textAllignment = NSTextAlignment.left
		view.placeHolderText = fieldModel.placeholder ?? ""
		view.itemTextColor = Colors.createScreenFormInputFocusColor
		view.titleColor = Colors.createScreenFormInputColor
		view.itemBackground = Colors.backgroundColor
		view.font = inputFont
		view.accessibilityIdentifier = fieldModel.name
		view.placeHolderText = fieldModel.placeholder ?? ""
		view.isCollapsed = true
		view.delegate = self
		view.tag = index
		let options: [FieldOption] = fieldModel.options ?? []

		view.items = options.map { ($0.value ?? "") }

		checkDropDownType(dropDown: view)
		hideTopLabel(view)
		setFieldStyle(view)

		view.snp.makeConstraints { make in
			make.height.equalTo(UITextField.preferredHeight * 1.2)
			make.width.equalTo(UIScreen.main.bounds.width - preferredSpacing * 6)
		}
		view.addArrowIcon(tintColor: Colors.createScreenFormInputColor)

		fields.append(view)
	}

	func addTextView(fieldModel: Field) {
		let view = CustomMessageTextView.create()
		setTextViewStyle(view.messageTextView)
		view.messageTextView.backgroundColor = .clear
		view.messageTextView.textColor = Colors.createScreenFormInputFocusColor
		view.messageTextView.tintColor = Colors.createScreenFormInputFocusColor
		view.messageTextView.accessibilityIdentifier = fieldModel.name
		view.messageTextView.delegate = self
		setInputFont(view.messageTextView)
		addMessageTextViewLabel(text: fieldModel.placeholder ?? "")
		fields.append(view)
		setFieldStyle(view.messageTextView)

		view.snp.makeConstraints { make in
			make.height.equalTo(UIButton.preferredHeight * 4)
		}

		configureTextViewTopLabels(view.frameView, fieldModel.placeholder ?? "")
	}

	func addMessageTextViewLabel (text: String) {
		let label = UILabel()
		label.tag = 30
		setInputFont(label)
		label.textColor = Colors.createScreenFormInputColor
		let paragraphStyle = NSMutableParagraphStyle()

		paragraphStyle.firstLineHeadIndent = preferredSpacing * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines
		label.snp.makeConstraints { $0.height.equalTo(UITextField.preferredHeight) }
		configureLabelTextAlignment(label)
		label.isHidden = true
		fields.append(label)
	}

}

// MARK: - HADropDownDelegate Configure
extension CreateRequestView: HADropDownDelegate {
	func willHide(dropDown: HADropDown) {
		scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
	}

	func willShow(dropDown: HADropDown) {
		self.endEditing(true)
	}

	func didHide(dropDown: HADropDown) {
		guard dropDown.getSelectedIndex != -1 else { return }
		showTopLabel(dropDown)

		guard dropDownListView.getSelectedIndex != -1 else {
			if dropDown.tag == 1 {
				dropDownListView.shake()
			}
			return
		}
	}

	func checkDropDownType(dropDown: HADropDown) {
		switch fieldType {
		case .line:
			dropDown.addViewUnderLine()
			dropDown.addTopLabel(text: dropDown.placeHolderText, textColor: Colors.createScreenLabelTextColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400)))
		case .box:
			dropDown.addTopLabel2(text: dropDown.placeHolderText, textColor: Colors.createScreenLabelTextColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400)))
		case .shadow:
			dropDown.addTopLabel3(text: dropDown.placeHolderText, textColor: Colors.createScreenLabelTextColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400)))
		}
	}

	func didSelectItem(dropDown: HADropDown, at index: Int) {
		guard index != -1 else { return }
		configureDropDownListViewUnderLine(dropDown: dropDown)
		dropDown.titleColor = Colors.createScreenFormInputFocusColor
		setIconImageTintColor(dropDownListView: dropDown)
		guard fieldType == .shadow else { return }
		dropDown.layer.borderColor = Colors.createScreenFormInputFocusBorderColor.cgColor
		dropDown.backgroundColor = Colors.createScreenFormInputFocusBackgroundColor
	}

	func configureDropDownListViewUnderLine(dropDown: HADropDown) {
		let subViews = dropDown.subviews
		for view in subViews where view.tag == 10 {
			view.backgroundColor = Colors.createScreenFormInputFocusBorderColor
		}
	}

	func setIconImageTintColor(dropDownListView: HADropDown) {
		let views = dropDownListView.subviews

		for view in views where view.tag == 2 {
			view.tintColor = Colors.createScreenFormInputFocusColor
		}
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
		let offset = CGPoint(x: 0, y: textView.superview?.frame.minY ?? 0)
		scrollView.setContentOffset(offset, animated: true)
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		var lastField: CustomMessageTextView?
		for field in fields {
			if let currentfield = field as? CustomMessageTextView {
				lastField = currentfield
			}
		}
		var offsetY: CGFloat = textView.superview?.frame.minY ?? 0
		guard let lastTextField = lastField else { return }
		if lastTextField.messageTextView == textView {
			let differance = ((textView.superview?.frame.height ?? 0) + UIButton.preferredHeight + (preferredSpacing * 2))
			offsetY -= differance
		}
		if scrollView.contentSize.height > scrollView.frame.size.height {
//			let offset = CGPoint(x: 0, y: offsetY)
//			scrollView.setContentOffset(offset, animated: true)
		} else {
			scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
		}

	}

	func textViewDidChange(_ textView: UITextView) {

		guard let frameView = textView.superview?.subviews[0] else { return  }

		guard let message = textView.trimmedText, message.count > 0 else {
			if fieldType == .shadow {
				frameView.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
				frameView.backgroundColor = Colors.createScreenFormInputBackgroundColor
			}
			textView.layer.borderColor = fieldType == .line ? Colors.createScreenFormInputBorderColor.cgColor : UIColor.clear.cgColor
			frameView.downPlaceholderUIView(color: Colors.createScreenFormInputColor)
			configureMessageLabelText(textView: textView, color: Colors.createScreenFormInputColor)
			hideTopPlaceHolders(frameView)
			configureBorderColor(textView: frameView, color: Colors.createScreenFormInputBorderColor)
			hideSpecialLayer(frameView)
			return
		}

		showTopPlaceHolders(frameView)
		showSpecialLayer(frameView)
		frameView.upPlaceholderUIView(color: Colors.createScreenLabelTextColor)
		configureMessageLabelText(textView: textView, color: Colors.createScreenLabelTextColor)
		configureBorderColor(textView: frameView, color: Colors.createScreenFormInputFocusBorderColor)
		if fieldType == .shadow {
			frameView.layer.borderColor = Colors.createScreenFormInputFocusBorderColor.cgColor
			frameView.backgroundColor = Colors.createScreenFormInputFocusBackgroundColor
		}
		textView.layer.borderColor = fieldType == .line ? Colors.createScreenFormInputFocusBorderColor.cgColor : UIColor.clear.cgColor

		messageTextViewLabel.text = Config.shared.model?.generalSettings?.messageFieldText
		guard textView == messageTextView.messageTextView else { return }
		messageTextViewErrorLabel.isHidden = true
	}

	func configureTextViewTopLabels(_ textView: UIView, _ placeholder: String) {
		if fieldType == .shadow {
			textView.addPlaceholderLabelToView(text: placeholder, textColor: Colors.createScreenFormInputColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.formInputFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.formInputFontWeight ?? 400)))
		} else if fieldType == .box {
			textView.addPlaceholderLabel2ToView(text: placeholder, textColor: Colors.createScreenFormInputColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.formInputFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.formInputFontWeight ?? 400)))
			textView.addTopLabelToView(text: placeholder, textColor: Colors.createScreenLabelTextColor, font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400)))
		}
	}

	func showTopPlaceHolders(_ textView: UIView?) {
		guard let textView = textView else { return }
		guard fieldType == .box else { return }
		let views = textView.subviews
		for view in views {
			if view.tag == 1 {
				view.isHidden = false
			} else if view.tag == 3 {
				view.isHidden = true
			}
		}
	}

	func hideTopPlaceHolders(_ textView: UIView?) {
		guard let textView = textView else { return }
		guard fieldType == .box else { return }
		let views = textView.subviews
		for view in views {
			if view.tag == 1 {
				view.isHidden = true
			} else if view.tag == 3 {
				view.isHidden = false
			}
		}
	}

	func configureBorderColor(textView: UIView, color: UIColor) {
		guard fieldType == .line else { return }
		textView.layer.borderColor = color.cgColor
	}

	func configureMessageLabelText(textView: UITextView, color: UIColor) {
		var currentIndex = 0
		fields.enumerated().forEach { index, value in
			if let currentView = value as? CustomMessageTextView {
				if currentView.messageTextView == textView {
					currentIndex = index
				}
			}
		}
		guard currentIndex > 1 else { return }
		(fields[currentIndex - 1] as? UILabel)?.textColor = color
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
			return true

		case dropDownListView:
			if dropDownListView.getSelectedIndex == -1 {
				dropDownListView.shake()
				dropDownListView.showList()
				return false
			}
			return true

		default:
			return true
		}
	}

	func configureErrorLabels(_ label: UILabel) {
		label.isHidden = true
		label.font = UIFont.systemFont(ofSize: 11)
		configureLabelTextAlignment(label)
	}

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: 100)
    }

    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}

// MARK: - Actions
extension CreateRequestView {

	@objc func didTap() {
		if !dropDownListView.isCollapsed {
			self.dropDownListView.hideList()
		}
		self.endEditing(true)
	}

	// swiftlint:disable cyclomatic_complexity
	@objc func checkTexFields(_ sender: UITextField) {

		configureUnderLine(field: sender)

		switch sender.tag {
		case 1:
			if let text = nameTextField.trimmedText, text.count > 0 {
                let count = text.count ?? 0
                nameFieldLimit.text = count < 10 ? "0\(count)/100" : "\(count)/100"
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputFocusBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputFocusBackgroundColor
				}
				nameErrorLabel.isHidden = true
				showTopLabel(sender)
			} else {
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputBackgroundColor
				}
				hideTopLabel(sender)
			}
		case 2:
			if let text = emailTextField.trimmedText, text.count > 0 {
                let count = text.count ?? 0
                emailFieldLimit.text = count < 10 ? "0\(count)/100" : "\(count)/100"
				showTopLabel(sender)
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputFocusBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputFocusBackgroundColor
				}
			} else {
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputBackgroundColor
				}
				hideTopLabel(sender)
			}
			if emailTextField.emailAddress != nil {
				emailErrorLabel.isHidden = true

			}
		case 3:
			if let text = sender.trimmedText, text.count > 0 {
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputFocusBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputFocusBackgroundColor
				}
				showTopLabel(sender)
			} else {
				if fieldType == .shadow {
					sender.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
					sender.backgroundColor = Colors.createScreenFormInputBackgroundColor
				}
				hideTopLabel(sender)
			}
		default:
			break

		}

	}

}

// MARK: - Helpers
private extension CreateRequestView {

	func configureLabelTextAlignment(_ label: UILabel) {
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
	}

	func configureTextViewAlignment(_ textView: UITextView) {
		textView.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
	}

	func setInputFont(_ field: UIView) {

		if let currentField = field as? UITextView {
			currentField.font = inputFont
		}

		if let currentField = field as? UILabel {
			currentField.font = inputFont
		}

		if let currentField = field as? UITextField {
			currentField.font = inputFont
		}

	}

	func setFieldStyle(_ field: UIView) {

		if let currentField = field as? UITextField {
			currentField.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		}

		switch fieldType {
		case .line:
			setFieldStyle1(field)
		case .box:
			setFieldStyle2(field)
		case .shadow:
			setFieldStyle3(field)
		}

	}

	func setFieldStyle1(_ view: UIView) {

		for view in fields {
			if let currentView = view as? UILabel {
				if currentView.tag == 30 {
					currentView.isHidden = false
				}
			}
		}
		messageTextViewLabel.isHidden = false
		view.backgroundColor = .clear
		view.tintColor = Colors.createScreenFormInputFocusColor

		if let textField = view as? UITextField {
            setupLimitFileds(textField: textField, bottomInset: 4, trailingInset: 0)
			textField.addUnderLine()
		}

		if let textView = view as? UITextView {
			textView.layer.borderWidth = 1
			textView.layer.cornerRadius = 4
			textView.clipsToBounds = true
			textView.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
			textView.textContainerInset = UIEdgeInsets.init(top: preferredSpacing / 2, left: preferredSpacing / 2, bottom: preferredSpacing / 2, right: preferredSpacing / 2)
		}
	}

    func setupLimitFileds(textField: UITextField, bottomInset: CGFloat, trailingInset: CGFloat) {
        if textField == nameTextField {
            nameFieldLimit.snp.makeConstraints { make in
                make.bottom.equalTo(nameTextField.snp.bottom).offset(bottomInset)
                make.trailing.equalTo(nameTextField.snp.trailing).offset(trailingInset)
            }
        }
        
        if textField == emailTextField {
            emailFieldLimit.snp.makeConstraints { make in
                make.bottom.equalTo(emailTextField.snp.bottom).offset(bottomInset)
                make.trailing.equalTo(emailTextField.snp.trailing).offset(trailingInset)
            }
            
        }
    }
    
	func setFieldStyle2(_ field: UIView) {
		field.tintColor = Colors.createScreenFormInputFocusColor
        if let tf = field as? UITextField {
            setupLimitFileds(textField: tf, bottomInset: -4, trailingInset: -6)
        }
		if let textView = field as? UITextView {
			textView.textContainerInset = UIEdgeInsets.init(top: preferredSpacing, left: preferredSpacing / 2, bottom: preferredSpacing / 2, right: preferredSpacing / 2)
		}
	}

	func setFieldStyle3(_ view: UIView) {

		if let currentView = view as? HADropDown {
			currentView.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
			currentView.layer.borderWidth = 1
		}

		if let textView = view as? UITextView {
			textView.textContainerInset = UIEdgeInsets.init(top: preferredSpacing, left: preferredSpacing / 2, bottom: preferredSpacing / 2, right: preferredSpacing / 2)
			if let currentView = textView.superview as? CustomMessageTextView {
				viewConfigure(currentView.frameView)
			}
		} else {
			viewConfigure(view)
		}

	}

	func viewConfigure(_ view: UIView) {
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true
		view.layer.borderWidth = 1
		view.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
		view.tintColor = Colors.createScreenFormInputFocusColor
		view.backgroundColor = Colors.createScreenFormInputBackgroundColor
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize.zero
		view.layer.shadowRadius = 10
		view.layer.shadowOpacity = 0.3
		view.layer.masksToBounds = false
	}

	func setTextViewStyle(_ textView: UITextView) {
		textView.textContainerInset = UIEdgeInsets.init(top: preferredSpacing, left: preferredSpacing / 2, bottom: preferredSpacing / 2, right: preferredSpacing / 2)

		configureTextViewAlignment(textView)
	}

	/// Returns width or height, whichever is the smaller value.
	func minDimension(size: CGSize) -> CGFloat {
		return min(size.width, size.height)
	}
}

// MARK: - Configure
extension CreateRequestView {

	func configure() {
		self.backgroundColor = Colors.backgroundColor

		fieldType = Config.shared.model?.createScreen?.formStyleId ?? .line

		addFields()
		configureDropDownListView()
		configureAttachmentComponent()
		configureLabels()

		setInputFont(nameTextField)
		setInputFont(emailTextField)

		messageTextView.messageTextView.textColor =  Colors.createScreenFormInputFocusColor
		messageTextView.messageTextView.tintColor =  Colors.createScreenFormInputFocusColor
		messageTextViewLabel.textColor = Colors.createScreenFormInputColor
		setInputFont(messageTextViewLabel)
		setInputFont(messageTextView.messageTextView)
		configureUnderLine(field: nameTextField)
		configureUnderLine(field: emailTextField)
		bottomDescriptionLabel.text = Config.shared.model?.createScreen?.bottomNoteText
        bottomDescriptionLabel.isHidden = !(Config.shared.model?.createScreen?.bottomNoteIsHidden ?? false)
		bottomDescriptionLabel.textColor = Colors.bottomNoteColor
        agreementButton.isHidden = !(Config.shared.model?.createScreen?.agreementIsHidden ?? false)
        agreementTextView.isHidden = !(Config.shared.model?.createScreen?.agreementIsHidden ?? false)
        let str = Config.shared.model?.createScreen?.agreementText ?? ""
        let attributedString = NSMutableAttributedString(string: str)
        if let url = Config.shared.model?.createScreen?.agreementUrl, url.count > 0 {
            let uri = URL(string: url)!
            attributedString.setAttributes([.link: uri], range: NSRange(location: 0, length: str.count))
            agreementTextView.linkTextAttributes = [
                .foregroundColor: Colors.createScreenFormInputColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        }
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: str.count))
        agreementTextView.attributedText = attributedString

		bottomDescriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.bottomNoteFontSize ?? 8), weight: Font.weight(type: Config.shared.model?.generalSettings?.bottomNoteFontWeight ?? 400))
		sendButton.layer.borderColor = Colors.createScreenButttonBorderColor.cgColor
		configureFields()
		setFieldStyle(messageTextView.messageTextView)
		setFieldStyle(nameTextField)
		setFieldStyle(emailTextField)
		setFieldStyle(dropDownListView)
		configureButton()

		configureTextViewTopLabels(messageTextView.frameView, Config.shared.model?.generalSettings?.messageFieldText ?? "")

		checkTexFields(nameTextField)
		checkTexFields(emailTextField)

		guard !(Config.shared.model?.createScreen?.bottomNoteIsHidden ?? false)  else { return }
		remakeScrollLyaout()
	}

	func configureDropDownListView() {
		dropDownListView.itemTextColor = Colors.createScreenFormInputFocusColor
		dropDownListView.titleColor = Colors.createScreenFormInputColor
		dropDownListView.itemBackground = Colors.backgroundColor
		dropDownListView.addArrowIcon(tintColor: Colors.createScreenFormInputColor)
		dropDownListView.placeHolderText = Config.shared.model?.generalSettings?.subjectFieldText ?? ""
		dropDownListView.title = Config.shared.model?.generalSettings?.subjectFieldText ?? ""
		dropDownListView.font = inputFont
		checkDropDownType(dropDown: dropDownListView)
		hideTopLabel(dropDownListView)
	}

	func configureAttachmentComponent() {
		attachmentButton.imageView?.tintColor = Colors.createScreenFormInputColor
		attachmentButton.setTitleColor(Colors.createScreenLabelTextColor, for: .normal)
		attachmentButton.setTitle(Config.shared.model?.generalSettings?.addFileText, for: .normal)
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			attachmentButton.imageView?.frame.origin.x = attachmentButton.frame.size.width - preferredSpacing * 0.5 - (attachmentButton.imageView?.frame.size.width ?? 0)
			attachmentButton.titleLabel?.frame.origin.x = 0

			attachmentButton.snp.remakeConstraints { remake in
				remake.width.equalTo((attachmentButton.titleLabel?.frame.size.width ?? 0) + (attachmentButton.imageView?.frame.size.width ?? 0) + preferredSpacing)
				remake.leading.top.bottom.equalToSuperview()
			}
			attachmentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: preferredSpacing * 0.5, bottom: 0, right: 0)
		} else {
			attachmentButton.imageView?.frame.origin.x = preferredSpacing * 0.5
			attachmentButton.titleLabel?.frame.origin.x = (attachmentButton.imageView?.frame.size.width ?? 0) + preferredSpacing

			attachmentButton.snp.remakeConstraints { remake in
				remake.width.equalTo((attachmentButton.titleLabel?.frame.size.width ?? 0) + (attachmentButton.imageView?.frame.size.width ?? 0) + preferredSpacing)
				remake.leading.top.bottom.equalToSuperview()
			}
			attachmentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: preferredSpacing * 0.5)
		}

		attachmentCancelButton.imageView?.tintColor = Colors.createScreenFormInputColor
		attachmentLabel.textColor = Colors.createScreenLabelTextColor
		attachmentLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400))
		attachmentContainerView.isHidden = !(Config.shared.model?.createScreen?.addedFileIsHidden ?? false)

	}

	func configureLabels() {
		nameErrorLabel.text = Config.shared.model?.generalSettings?.requiredFieldMessage
		emailErrorLabel.text = Config.shared.model?.generalSettings?.requiredEmailFieldMessage
		messageTextViewErrorLabel.text = Config.shared.model?.generalSettings?.requiredMessageViewMessage

		configureErrorLabel(label: nameErrorLabel)
		configureErrorLabel(label: emailErrorLabel)
		configureErrorLabel(label: messageTextViewErrorLabel)
	}

	func configureErrorLabel(label: UILabel) {
		label.textColor = Colors.createScreenErrorLabelTextColor
	}

	func configureField(field: UITextField) {

		if fieldType == .shadow {
			field.backgroundColor = Colors.createScreenFormInputBackgroundColor
			field.layer.borderColor = Colors.createScreenFormInputBorderColor.cgColor
		} else {
			field.backgroundColor = .clear
		}

		field.setPlaceHolderTextColor(Colors.createScreenFormInputColor)
		field.textColor = Colors.createScreenFormInputFocusColor
		field.tintColor = Colors.createScreenFormInputFocusColor

	}

	func configureFields() {

		nameTextField.placeholder = Config.shared.model?.generalSettings?.nameFieldText
		emailTextField.placeholder = Config.shared.model?.generalSettings?.emailFieldText

		configureField(field: nameTextField)
		configureField(field: emailTextField)

		checkTopLabels(field: nameTextField, text: Config.shared.model?.generalSettings?.nameFieldText ?? "")
		checkTopLabels(field: emailTextField, text: Config.shared.model?.generalSettings?.emailFieldText ?? "")

		hideTopLabel(nameTextField)
		hideTopLabel(emailTextField)

	}

	func showTopLabel(_ currentView: UIView) {

		for view in currentView.subviews where view.tag == 1 {
			view.isHidden = false
		}

		showSpecialLayer(currentView)
	}

	func hideTopLabel(_ currentView: UIView) {

		for view in currentView.subviews where view.tag == 1 {
			view.isHidden = true
		}

		hideSpecialLayer(currentView)
	}

	func showSpecialLayer(_ currentView: UIView?) {
		guard let currentView = currentView else { return }
		guard let layers = currentView.layer.sublayers else { return }

		for layer in layers {
			if layer.name == "specialLayer" {
				layer.isHidden = false
			} else if layer.name == "borderLayer" {
				layer.isHidden = true
			}
		}
	}

	func hideSpecialLayer(_ currentView: UIView?) {
		guard let currentView = currentView else { return }
		guard let layers = currentView.layer.sublayers else { return }

		for layer in layers {
			if layer.name == "specialLayer" {
				layer.isHidden = true
			} else if layer.name == "borderLayer" {
				layer.isHidden = false
			}
		}
	}

	func configureUnderLine(field: UITextField) {
		let subViews = field.subviews
		for view in subViews where view.tag == 10 {
			if let text = field.trimmedText, text.count > 0 {
				view.backgroundColor = Colors.createScreenFormInputFocusBorderColor
			} else {
				view.backgroundColor = Colors.createScreenFormInputBorderColor
			}
		}
	}

	func checkTopLabels(field: UITextField, text: String) {
		let fontWeight = Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400)
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: fontWeight)
		let fontForShadow = UIFont.systemFont(ofSize: CGFloat(12), weight: fontWeight)
		let textColor = Colors.createScreenLabelTextColor

		switch fieldType {
		case .line:
			field.addTopLabel(text: text, textColor: textColor, font: font, origin: CGPoint(x: 0, y: -preferredSpacing * 0.4))
		case .box:
			field.addType2TopLabel(text: text, textColor: textColor, font: font, backgroundColor: Colors.backgroundColor)
		case .shadow:
			field.addTopLabel(text: text, textColor: textColor, font: fontForShadow, origin: CGPoint(x: 0, y: 2))
		}
	}

	func remakeScrollLyaout() {
		scrollView.snp.remakeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360BottomView.snp.top)
		}
	}

}

// MARK: - Configure Send Button
extension CreateRequestView {

	func configureButton() {
		ticketTypes = Config.shared.model?.createScreen?.ticketTypes ?? []
		setTicketType(ticketTypes: ticketTypes)
		sendButton.backgroundColor = Colors.createScreenButtonBackgroundColor
		sendButton.layer.borderColor = Colors.createScreenButttonBorderColor.cgColor
		sendButton.setTitleColor(Colors.createScreenButtonTextColor, for: .normal)
        if Config.shared.model?.createScreen?.agreementIsHidden == true {
            sendButton.isEnabled = false
            sendButton.setTitleColor(.gray, for: .normal)
        }
		sendButton.tintColor = Colors.createScreenButtonTextColor
		sendButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.buttonTextFontSize ?? 14), weight: Font.weight(type: Config.shared.model?.createScreen?.buttonTextFontWeight ?? 400))
		sendButton.setTitle(Config.shared.model?.createScreen?.buttonText, for: .normal)
		sendButton.layer.shadowColor = UIColor.clear.cgColor
		sendButton.setImage(UIImage(), for: .normal)
		let type = Config.shared.model?.createScreen?.buttonStyleId

		let imageIshidden =  Config.shared.model?.createScreen?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model?.createScreen?.buttonShadowIsHidden ?? true

		switch type {
		case .radius1:
			sendButtonType1()
		case .radius2:
			sendButtonType2()
		case .sharp:
			sendButtonType3()
		case .fullWidth:
			sendButtonType4()
		default:
			sendButtonType1()
		}

		if imageIshidden {
			sendButton.setImage(Desk360.Config.Images.unreadIcon, for: .normal)
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				sendButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
			} else {
				sendButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
			}
			sendButton.imageView?.tintColor = Colors.createScreenButtonTextColor
		}

		if buttonShadowIsHidden {
			sendButton.layer.shadowColor = UIColor.black.cgColor
			sendButton.layer.shadowOffset = CGSize.zero
			sendButton.layer.shadowRadius = 10
			sendButton.layer.shadowOpacity = 0.3
			sendButton.layer.masksToBounds = false
		}
	}

	func sendButtonType1() {
		sendButton.layer.cornerRadius = 22
		setupButtonDefaultLayout()
	}

	func sendButtonType2() {
		sendButton.layer.cornerRadius = 10
		setupButtonDefaultLayout()
	}

	func sendButtonType3() {
		sendButton.layer.cornerRadius = 2
		setupButtonDefaultLayout()
	}

	func sendButtonType4() {

		sendButton.layer.cornerRadius = 0

		sendButton.snp.remakeConstraints { make in
            make.top.equalTo(agreementView.snp.bottom).offset(preferredSpacing * 0.4)
			make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) + 2)
			make.bottom.equalToSuperview()
		}
	}

	func setupButtonDefaultLayout() {
		sendButton.snp.remakeConstraints { make in
            make.top.equalTo(agreementView.snp.bottom).offset(preferredSpacing * 0.4)
            make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
			make.width.equalTo(stackView)
			make.bottom.equalToSuperview().inset(preferredSpacing)
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
		self.scrollView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
	}

	/// Called right after the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidHide(_ notification: KeyboardNotification?) {
		self.scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
	}

	/// Called right after the keyboard is presented.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidShow(_ notification: KeyboardNotification?) {
		let height = notification?.endFrame.size.height ?? 300
		self.scrollView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
	}

	/// Called right before the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardWillHide(_ notification: KeyboardNotification?) {
		self.scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
		self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: true)
	}

	/// Called right before the keyboard is about to change its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardWillChangeFrame(_ notification: KeyboardNotification?) { }

	/// Called right after the keyboard did changed its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	public func keyboardDidChangeFrame(_ notification: KeyboardNotification?) { }

}
