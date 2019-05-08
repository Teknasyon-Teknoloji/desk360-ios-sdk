//
//  Extensions.swift
//  Desk360
//
//  Created by Omar on 5/8/19.
//

import Foundation

internal extension Locale {

	/// Country code.
	var countryCode: String {
		let nsLocale = self as NSLocale
		return nsLocale.object(forKey: .countryCode) as! String
	}

}

internal extension UIDevice {

	var uniqueIdentifier: String {
		return ""
	}

}
