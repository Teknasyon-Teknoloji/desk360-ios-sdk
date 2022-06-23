//
//  UIView+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/13/19.
//

import UIKit
import SnapKit

extension UIView {

	/// Get `safeAreaLayoutGuide.snp` or fallback to `self.snp` if not possible.
	var safeArea: ConstraintBasicAttributesDSL {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.snp
		}
		return self.snp
	}

	/// Shake view.
	///
	/// - Parameters:
	///   - duration: animation duration in seconds _default value is 1.0 second_.
	///   - delay: animation delay in seconds _default value is 0.0 second_.
	///   - completion: optional completion handler to run with animation finishes _default value is nil_.
	func shake(withDuration duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
			CATransaction.begin()
			let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			CATransaction.setCompletionBlock(completion)
			animation.duration = duration
			animation.values = [-15.0, 15.0, -12.0, 12.0, -8.0, 8.0, -3.0, 3.0, 0.0]
			self.layer.add(animation, forKey: "shake")
			CATransaction.commit()
		}
	}

	func roundCorners(_ corners: UIRectCorner, radius: CGFloat, isShadow: Bool) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		if isShadow {
			mask.shadowColor = UIColor.black.cgColor
			mask.shadowOffset = self.frame.size
			mask.shadowRadius = 10
			mask.shadowOpacity = 0.3
			mask.masksToBounds = false
		}
		self.layer.mask = mask
	}

	func addViewUnderLine() {
		let bottomLine = UIView()
		bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: UITextField.preferredHeight), size: CGSize(width: UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2), height: 1))
		bottomLine.backgroundColor = Colors.createScreenFormInputBorderColor
		bottomLine.tag = 10
		self.addSubview(bottomLine)
	}

	func addPlaceholderLabelToView(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 2
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 3.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 1.2
		label.frame.origin.x = (UIScreen.main.bounds.size.minDimension * 0.054) * 0.75
		label.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
		label.font = font
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		label.text = text
		label.textColor = textColor
		label.baselineAdjustment = .alignBaselines
		self.clipsToBounds = false

		self.addSubview(label)
	}

	func addPlaceholderLabel2ToView(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 3
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 3.5)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 1.2
		label.frame.origin.x = (UIScreen.main.bounds.size.minDimension * 0.054) * 0.75
		label.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
		label.font = font
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
		label.text = text
		label.textColor = textColor
		label.baselineAdjustment = .alignBaselines
		self.clipsToBounds = false

		self.addSubview(label)
	}

	// swiftlint:disable function_body_length
	func addTopLabelToView(text: String, textColor: UIColor, font: UIFont) {
		let label = UILabel()
		label.tag = 1
		label.frame.size.width = UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 3)
		label.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054
		label.frame.origin.x = 0
		label.frame.origin.y = -(UIScreen.main.bounds.size.minDimension * 0.054) * 0.4
		label.font = font
		label.textAlignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right: .left
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
		bezierPath.addLine(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.4), y: 0))
		bezierPath.move(to: CGPoint(x: ((UIScreen.main.bounds.size.minDimension * 0.054) * 0.3) + label.frame.size.width, y: 0))
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
	}

	func upPlaceholderUIView(color: UIColor) {
		guard Config.shared.model?.createScreen?.formStyleId == .shadow else { return }
		let views = self.subviews
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.labelTextFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.labelTextFontWeight ?? 400))
		for view in views where view.tag == 2 {
			view.frame.origin.y = 2
			if let currentView = view as? UILabel {
				currentView.textColor = color
				currentView.font = font
				currentView.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054
			}
		}

	}

	func downPlaceholderUIView(color: UIColor) {
		guard Config.shared.model?.createScreen?.formStyleId == .shadow else { return }
		let views = self.subviews
		let font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createScreen?.formInputFontSize ?? 11), weight: Font.weight(type: Config.shared.model?.createScreen?.formInputFontWeight ?? 400))

		for view in views where view.tag == 2 {
			view.frame.origin.y = UIScreen.main.bounds.size.minDimension * 0.054
			if let currentView = view as? UILabel {
				currentView.textColor = color
				currentView.font = font
				currentView.frame.size.height = UIScreen.main.bounds.size.minDimension * 0.054 * 1.2
			}
		}
	}
    
    func setBorder(width: CGFloat? = nil, color: UIColor? = nil, radius: CGFloat? = nil) {
        if let aWidth = width {
            layer.borderWidth = aWidth
        }

        if let aColor = color?.cgColor {
            layer.borderColor = aColor
        }

        if let aRadius = radius {
            layer.cornerRadius = aRadius
            layer.masksToBounds = true
        }
    }
}
