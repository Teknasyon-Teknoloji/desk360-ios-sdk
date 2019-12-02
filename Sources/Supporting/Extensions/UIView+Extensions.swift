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
		bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: UITextField.preferredHeight * 1.15 - 1), size: CGSize(width: UIScreen.main.bounds.width - ((UIScreen.main.bounds.size.minDimension * 0.054) * 2), height: 1))
		bottomLine.backgroundColor = Colors.createScreenFormInputBorderColor
		bottomLine.tag = 10
		self.addSubview(bottomLine)
	}

}
