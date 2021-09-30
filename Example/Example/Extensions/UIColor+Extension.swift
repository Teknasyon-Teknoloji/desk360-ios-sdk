//
//  UIColor+Extension.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

extension UIColor {

	convenience init?(hex: String?) {
		guard let aHex = hex else { return nil }
		var hexSanitized = aHex.trimmingCharacters(in: .whitespacesAndNewlines)
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

		var rgb: UInt32 = 0

		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		var a: CGFloat = 1.0

		let length = hexSanitized.count

		guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

		if length == 6 {
			r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
			g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
			b = CGFloat(rgb & 0x0000FF) / 255.0

		} else if length == 8 {
			r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
			g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
			b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
			a = CGFloat(rgb & 0x000000FF) / 255.0

		} else {
			return nil
		}

		self.init(red: r, green: g, blue: b, alpha: a)
	}

	/// Hexadecimal value string.
	///
	/// - Parameters:
	///   - includeHashSign: Whether to include # sign at the beginning or not. _default value is false_.
	///   - includeAlpha: Whether to include alpha or not. _default value is false_.
	/// - Returns: Hexadecimal representation of a `UIColor` as `String`
	func hexString(includeHashSign: Bool = false, includeAlpha: Bool = false) -> String? {
		let components = cgColor.components ?? []

		let r: Float
		let g: Float
		let b: Float
		let a: Float

		switch components.count {
		case 2:
			r = Float(components[0])
			g = Float(components[0])
			b = Float(components[0])
			a = Float(components[1])

		case 3, 4:
			r = Float(components[0])
			g = Float(components[1])
			b = Float(components[2])
			a = Float(components[3])

		default:
			return nil
		}

		var hexStr: String
		if includeAlpha {
			hexStr = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
		} else {
			hexStr = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
		}

		if includeHashSign {
			hexStr.insert("#", at: hexStr.startIndex)
		}

		return hexStr
	}

}
