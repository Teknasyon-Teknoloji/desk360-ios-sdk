//
//  UITextField+Extensions.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import DeviceKit


private var height: CGFloat = {
	let diagonal = Device.current.realDevice.diagonal
	if diagonal >= 6 && diagonal < 7 { return 58.0 }
	if diagonal >= 5 && diagonal < 6 { return 55.0 }
	if diagonal >= 4 && diagonal < 5 { return 45.0 }
	return 50.0
}()

extension UITextField {

	/// Use `TextType` to set up common text input properties for `UITextField`.
	enum TextType {

		/// Specifies the expectation of a generic text.
		case generic

		/// Specifies the expectation of an account or login name.
		case username

		/// Specifies the expectation of an email address.
		case emailAddress

		/// Specifies the expectation of a URL.
		case url

		/// Specifies the expectation of a telephone number.
		case telephoneNumber

		/// Specifies the expectation of a decimal number.
		case decimal

		/// Specifies the expectation of a password.
		case password

	}

	/// Creates and returns a new UITextField with setting its properties in one line.
	///
	/// - Parameters:
	///   - textAlignment: The technique to use for aligning the text _(default is .natural)_.
	///   - textType: The text field's text type _(default is .generic)_.
	///   - textColor: The color of the text _(default is .black)_.
	///   - font: The font of the text _(default is nil)_.
	///   - borderStyle: The type of border drawn around the text field _(default is .none)_.
	///   - backgroundColor: The text field's background color _(default is nil)_.
	///   - tintColor: The tint color of the text field _(default is nil)_.
	/// - Returns: UITextField
	static func create(
		textAlignment: NSTextAlignment = .natural,
		textType: TextType = .generic,
		textColor: UIColor? = .black,
		font: UIFont? = nil,
		borderStyle: UITextField.BorderStyle = .none,
		backgroundColor: UIColor? = nil,
		tintColor: UIColor? = nil) -> UITextField {

		let field = UITextField()

		field.textAlignment = textAlignment
		field.setTextType(textType)
		field.textColor = textColor

		if let aFont = font {
			field.font = aFont
		}

		field.borderStyle = borderStyle

		if let color = backgroundColor {
			field.backgroundColor = color
		}

		if let color = tintColor {
			field.tintColor = color
		}

		return field
	}

	/// Preferred height for autolayout.
	static var preferredHeight: CGFloat {
		return height
	}

	/// Text field text as email address (if applicable).
	var emailAddress: String? {
		guard let possibleEmail = trimmedText else { return nil }
		return possibleEmail.emailAddress
	}

	/// Check if text field's text is a valid email address.
	var hasValidEmail: Bool {
		return emailAddress != nil
	}

	/// text field's text trimming whitespaces and new lines.
	var trimmedText: String? {
		guard let aText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
		guard !aText.isEmpty else { return nil }
		return aText
	}

	/// Check if text field is empty.
	var isEmpty: Bool {
		return trimmedText == nil
	}

	/// Set placeholder text color.
	///
	/// - Parameter color: placeholder text color.
	func setPlaceHolderTextColor(_ color: UIColor) {
		guard let holder = self.placeholder, !holder.isEmpty else { return }
		self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
	}

	// swiftlint:disable cyclomatic_complexity
	/// Set text field's text type.
	///
	/// - Parameter textType: `TextType`
	func setTextType(_ textType: TextType) {
		self.isSecureTextEntry = (textType == .password)

		switch textType {

		case .generic:
			self.keyboardType = .asciiCapable
			self.autocorrectionType = .default
			self.autocapitalizationType = .sentences

		case .username:
			self.keyboardType = .asciiCapable
			self.autocorrectionType = .no
			self.autocapitalizationType = .none
			if #available(iOS 11.0, *) {
				self.textContentType = .username
			}

		case .emailAddress:
			self.keyboardType = .emailAddress
			self.autocorrectionType = .no
			self.autocapitalizationType = .none
			if #available(iOS 10.0, *) {
				self.textContentType = .emailAddress
			}

		case .url:
			self.keyboardType = .URL
			self.autocorrectionType = .no
			self.autocapitalizationType = .none
			if #available(iOS 10.0, *) {
				self.textContentType = .URL
			}

		case .telephoneNumber:
			if #available(iOS 10.0, *) {
				self.keyboardType = .asciiCapableNumberPad
			} else {
				self.keyboardType = .numberPad
			}
			if #available(iOS 10.0, *) {
				self.textContentType = .telephoneNumber
			}

		case .decimal:
			self.keyboardType = .decimalPad

		case .password:
			self.keyboardType = .asciiCapable
			self.autocorrectionType = .no
			self.autocapitalizationType = .none
			if #available(iOS 11.0, *) {
				self.textContentType = .password
			}
		}
	}

}
