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

}
