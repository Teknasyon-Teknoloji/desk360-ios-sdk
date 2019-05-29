//
//  UINavigationBar+Extensions.swift
//  Alamofire
//
//  Created by samet on 28.05.2019.
//

import UIKit

public extension UINavigationBar {

	/// Set Navigation bar's title color and font.
	///
	/// - Parameters:
	///   - font: title font
	///   - color: title text color.
	func setTitleFont(_ font: UIFont, color: UIColor) {
		var attrs = [NSAttributedString.Key: Any]()
		attrs[.font] = font
		attrs[.foregroundColor] = color
		self.titleTextAttributes = attrs
	}

	/// Set navigation bar's background and text colors
	///
	/// - Parameters:
	///   - background: backgound color
	///   - text: text color
	func setColors(background: UIColor, text: UIColor) {
		self.isTranslucent = false
		self.backgroundColor = background
		self.barTintColor = background
		self.setBackgroundImage(UIImage(), for: .default)
		self.tintColor = text
		self.titleTextAttributes = [.foregroundColor: text]
	}

	/// Make navigation bar transparent.
	///
	/// - Parameter tint: tint color _default value is UIColor.black_.
	func makeTransparent(withTint tint: UIColor = .black) {
		self.isTranslucent = true
		self.backgroundColor = .clear
		self.barTintColor = .clear
		self.setBackgroundImage(UIImage(), for: .default)
		self.tintColor = tint
		self.titleTextAttributes = [.foregroundColor: tint]
		self.shadowImage = UIImage()
	}

}

