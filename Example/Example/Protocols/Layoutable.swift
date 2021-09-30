//
//  Layoutable.swift
//  Example
//
//  Created by samet on 13.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

/// Conform to `Layoutable` in `UIView` classes to setup its subviews and autolayout.
protocol Layoutable: AnyObject {

	/// Setup the view and it's subviews here.
	func setupViews()

	/// Add layout code here.
	func setupLayout()

	/// Preferred spacing for autolayout _default value is UIScreen.main.bounds.width * 0.054_.
	var preferredSpacing: CGFloat { get }

}

// MARK: - Default implementation for UIView.
extension Layoutable where Self: UIView {

	/// Preferred spacing for autolayout _default value is UIScreen.main.bounds.size.minDimension * 0.054_.
	var preferredSpacing: CGFloat {
		return UIScreen.main.bounds.size.width * 0.054
	}

	/// Create view.
	///
	/// - Parameters:
	///   - setupViews: whether to call `setupViews` method or not. _default value is true_
	///   - setupLayout: whether to call `setupLayout` method or not. _default value is true_
	/// - Returns: `self`
	static func create(setupViews: Bool = true, setupLayout: Bool = true) -> Self {
		let view = Self()
		if setupViews {
			view.setupViews()
		}
		if setupLayout {
			view.setupLayout()
		}
		return view
	}

}
