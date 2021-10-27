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

final class SupportTextField: UITextField {
    var padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
   
    init(padding: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

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

	func removeTopLabel() {
		for view in self.subviews where view.tag == 1 {
			view.removeFromSuperview()
		}
	}

	// swiftlint:disable function_body_length
	func addType2TopLabel(text: String, textColor: UIColor, font: UIFont, backgroundColor: UIColor) {
		let label = UILabel()
		label.tag = 1
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.8
		label.frame.origin.x = 0
		label.frame.origin.y = -(UIScreen.main.bounds.size.minDimension * 0.054) * 0.4
		label.font = font
		label.textAlignment = .center
		label.text = text

		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines

		self.addSubview(label)
		label.sizeToFit()

		let width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		let height = UITextField.preferredHeight * 1.2

		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: width - 4, y: height))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: 0, y: 4))
		bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.4), y: 0))
		bezierPath.move(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.2) + label.frame.size.width, y: 0))
		bezierPath.addLine(to: CGPoint(x: width - 4, y: 0))
		bezierPath.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2, y: 0), controlPoint2: CGPoint(x: width, y: 2))
		bezierPath.addLine(to: CGPoint(x: width, y: height - 4))
		bezierPath.addCurve(to: CGPoint(x: width - 4, y: height), controlPoint1: CGPoint(x: width, y: height - 2), controlPoint2: CGPoint(x: width - 2, y: height))

		let specialFrameLayer = CAShapeLayer()
		specialFrameLayer.path = bezierPath.cgPath
		specialFrameLayer.frame = CGRect(x: 0,
											y: 0,
											width: width,
											height: height)
		specialFrameLayer.strokeColor = Colors.createScreenFormInputFocusBorderColor.cgColor
		specialFrameLayer.fillColor = UIColor.clear.cgColor
		specialFrameLayer.name = "specialLayer"

		let bezierPathBorder = UIBezierPath()
		bezierPathBorder.move(to: CGPoint(x: width - 4, y: height))
		bezierPathBorder.addLine(to: CGPoint(x: 4, y: height))
		bezierPathBorder.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPathBorder.addLine(to: CGPoint(x: 0, y: 4))
		bezierPathBorder.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPathBorder.addLine(to: CGPoint(x: width - 4, y: 0))
		bezierPathBorder.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2, y: 0), controlPoint2: CGPoint(x: width, y: 2))
		bezierPathBorder.addLine(to: CGPoint(x: width, y: height - 4))
		bezierPathBorder.addCurve(to: CGPoint(x: width - 4, y: height), controlPoint1: CGPoint(x: width, y: height - 2), controlPoint2: CGPoint(x: width - 2, y: height))

		let borderLayer = CAShapeLayer()
		borderLayer.path = bezierPathBorder.cgPath
		borderLayer.frame = CGRect(x: 0,
								   y: 0,
								   width: width,
								   height: height)
		borderLayer.strokeColor = Colors.createScreenFormInputBorderColor.cgColor
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.name = "borderLayer"

		if let layers = self.superview?.layer.sublayers {
			for layer in layers where layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		}

		specialFrameLayer.isHidden = true
		self.layer.insertSublayer(borderLayer, below: specialFrameLayer)
		self.layer.insertSublayer(specialFrameLayer, below: label.layer)
		self.layoutIfNeeded()
		self.layoutSubviews()
	}

	// TODO: merge with addType3Toplabel Use origin y parameter.
	func addTopLabel(text: String, textColor: UIColor, font: UIFont, origin: CGPoint) {
		let label = UILabel()
		label.tag = 1
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.8
		label.frame.origin = origin
		label.font = font
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		label.text = text
		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.3
		self.clipsToBounds = false

		self.addSubview(label)
	}

	func addType3TopLabel(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 0.7
		label.frame.origin = .init(x: 0, y: 3)
		label.font = font
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		label.text = text
		label.textColor = textColor
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = UIScreen.main.bounds.size.minDimension * 0.054 * 0.5
		label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
		label.baselineAdjustment = .alignBaselines
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.3
		self.clipsToBounds = false

		self.addSubview(label)
	}

	func addUnderLine() {
		let bottomLine = UIView()
		bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: UITextField.preferredHeight - 2), size: CGSize(width: UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2), height: 1))
		bottomLine.backgroundColor = Colors.createScreenFormInputBorderColor
		bottomLine.tag = 10
		self.borderStyle = UITextField.BorderStyle.none
		self.addSubview(bottomLine)
	}

	func designTextField(placeholder: String, content: String?) {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))

		self.isEnabled = true
        self.leftView = paddingView
		self.leftViewMode = UITextField.ViewMode.always
        self.layer.cornerRadius = self.bounds.height * 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.attributedPlaceholder = NSAttributedString(string: NSLocalizedString(placeholder, comment: ""),
														attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor ])
		self.textColor = .white
    }

}
