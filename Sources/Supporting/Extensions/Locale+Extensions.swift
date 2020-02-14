//
//  Locale+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

extension Locale {

	/// Country code.
	var countryCode: String {
		let nsLocale = self as NSLocale
		return nsLocale.object(forKey: .countryCode) as? String ?? "en"
	}

}
