//
//  DateFormat.swift
//  Desk360
//
//  Created by Omar Albeik on 17.09.2018.
//

import Foundation

/// Common date formats used by Desk360 API services.
///
/// - `default`: "yyyy-MM-dd HH:mm:ss"
/// - raadable: "dd.MM.yyyy - HH:mm"
/// - rfc3339: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
/// - iso8601: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
/// - iso8601WithoutMilliseconds: "yyyy-MM-dd'T'HH:mm:ss'Z'"
public enum DateFormat: String, CaseIterable {

	/// "yyyy-MM-dd HH:mm:ss"
	case `default` = "yyyy-MM-dd HH:mm:ss"

	/// "dd.MM.yyyy - HH:mm"
	case raadable = "dd.MM.yyyy - HH:mm"

	/// "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
	case rfc3339 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

	/// "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

	/// "yyyy-MM-dd'T'HH:mm:ss'Z'"
	case iso8601WithoutMilliseconds = "yyyy-MM-dd'T'HH:mm:ss'Z'"

}

public extension DateFormat {

	/// Generate a DateFormatter and set it's dateFormat for a DateFormat option.
	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.locale = .init(identifier: "en_US_POSIX")
		formatter.dateFormat = rawValue
		return formatter
	}

}
