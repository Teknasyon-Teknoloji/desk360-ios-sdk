//
//  UITextView+Extensions.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

extension UITextView {

	/// Creates and returns a new UITextView with setting its properties in one line.
	///
	/// - Parameters:
	///   - font: The font of the text _(default is system font)_.
	///   - textColor: The color of the text _(default is .black)_.
	///   - isEditable: A Boolean value indicating whether the receiver is editable _(default is true)_.
	///   - allowsEditingTextAttributes: A Boolean value indicating whether the text view allows the user to edit style information _(default is false)_.
	///   - textAlignment: The technique to use for aligning the text _(default is .natural)_.
	///   - textContainerInset: The inset of the text container's layout area within the text view's content area _(default is nil)_.
	///   - backgroundColor: The text-view's background color _(default is nil)_.
	///   - tintColor: Text color of the view _(default is nil)_.
	/// - Returns: UITextView.
	static func create(
		font: UIFont? = nil,
		textColor: UIColor? = .black,
		isEditable: Bool = true,
		allowsEditingTextAttributes: Bool = false,
		textAlignment: NSTextAlignment = .natural,
		textContainerInset: UIEdgeInsets? = nil,
		backgroundColor: UIColor? = nil,
		tintColor: UIColor? = nil) -> UITextView {

		let view = UITextView()

		if let aFont = font {
			view.font = aFont
		}

		view.textColor = textColor
		view.isEditable = isEditable
		view.allowsEditingTextAttributes = allowsEditingTextAttributes
		view.textAlignment = textAlignment

		if let inset = textContainerInset {
			view.textContainerInset = inset
		}

		if let color = backgroundColor {
			view.backgroundColor = color
		}

		if let color = tintColor {
			view.tintColor = color
		}

		return view
	}

	func addPlaceholderLabel(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 2
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 1.2
		label.frame.origin.x = (UIScreen.main.bounds.size.minDimension * 0.054) * 0.75
		label.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
		label.font = font
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			label.textAlignment = .right
		} else {
			label.textAlignment = .left
		}
		label.text = text
		label.textColor = textColor
		label.baselineAdjustment = .alignBaselines
		self.clipsToBounds = false

		self.addSubview(label)
	}

	func addPlaceholderLabel2(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 3
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054
		label.frame.origin.x = (UIScreen.main.bounds.size.minDimension * 0.054) * 0.75
		label.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
		label.font = font
		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			label.textAlignment = .right
		} else {
			label.textAlignment = .left
		}
		label.text = text
		label.textColor = textColor
		label.baselineAdjustment = .alignBaselines
		self.clipsToBounds = false
		
		self.addSubview(label)
	}

	func addTopLabel(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 
		label.frame.origin.x = 0
		label.frame.origin.y = -(UIScreen.main.bounds.size.minDimension * 0.054) * 0.25
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
		label.isHidden = true


		let width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2)
		let height = UIButton.preferredHeight * 4

		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: width - 4, y: height))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: 0, y: 4))
		bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.4) , y: 0))
		bezierPath.move(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.3) + label.frame.size.width , y: 0))
		bezierPath.addLine(to: CGPoint(x: width - 4 , y: 0))
		bezierPath.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2 , y: 0), controlPoint2: CGPoint(x: width , y: 2))
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
		bezierPath.move(to: CGPoint(x: width - 4, y: height))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: 0, y: height - 4), controlPoint1: CGPoint(x: 2, y: height), controlPoint2: CGPoint(x: 0, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: 0, y: 4))
		bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 2), controlPoint2: CGPoint(x: 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: width - 4 , y: 0))
		bezierPath.addCurve(to: CGPoint(x: width, y: 4), controlPoint1: CGPoint(x: width - 2 , y: 0), controlPoint2: CGPoint(x: width , y: 2))
		bezierPath.addLine(to: CGPoint(x: width, y: height - 4))
		bezierPath.addCurve(to: CGPoint(x: width - 4, y: height), controlPoint1: CGPoint(x: width, y: height - 2), controlPoint2: CGPoint(x: width - 2, y: height))

		let borderLayer = CAShapeLayer()
		borderLayer.path = bezierPath.cgPath
		borderLayer.frame = CGRect(x: 0,
								   y: 0,
								   width: width,
								   height: height)
		borderLayer.strokeColor = Colors.createScreenFormInputBorderColor.cgColor
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.name = "borderLayer"

		if let layers = self.superview?.layer.sublayers {
			for layer in layers {
				if let currentLayer = layer as? CAShapeLayer {
					layer.removeFromSuperlayer()
				}
			}
		}

		specialFrameLayer.isHidden = true
		self.layer.insertSublayer(borderLayer, below: specialFrameLayer)
		self.layer.insertSublayer(specialFrameLayer, below: label.layer)
	}

	func upPlaceholder(color: UIColor) {
		guard Config.shared.model.createScreen?.formStyleId == 3 else { return }
		let views = self.subviews
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model.createScreen?.labelTextFontWeight ?? 400))
		for view in views {
			if view.tag == 2 {
				view.frame.origin.y = 0
				if let currentView = view as? UILabel {
					currentView.textColor = color
					currentView.font = font
					currentView.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 
				}
			}
		}


	}

	func downPlaceholder(color: UIColor) {
		guard Config.shared.model.createScreen?.formStyleId == 3 else { return }
		let views = self.subviews
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.createScreen?.formInputFontSize ?? 11), weight: Font.weight(type: Config.shared.model.createScreen?.formInputFontWeight ?? 400))

		for view in views {
			if view.tag == 2 {
				view.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
				if let currentView = view as? UILabel {
					currentView.textColor = color
					currentView.font = font
					currentView.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 1.2
				}
			}
		}
	}


	/// text field's text trimming whitespaces and new lines.
	var trimmedText: String? {
		let aText = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !aText.isEmpty else { return nil }
		return aText
	}

	/// Check if text view is empty.
	var isEmpty: Bool {
		return trimmedText == nil
	}

}
