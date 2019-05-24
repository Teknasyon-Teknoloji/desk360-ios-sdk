//
//  String+Extensions.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

extension String {

	/// Check validate email adress
	var emailAddress: String? {
		guard !self.isEmpty else { return nil }
		let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"

		guard self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil else { return nil }
		return self
	}

	/// Get a url escaped version of a string.
	var urlEscaped: String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}

	/// Encode a string into Data using UTF8.
	var utf8Encoded: Data {
		return self.data(using: .utf8)!
	}

	/// Whether a string has a STATIC_KEY format or not.
	var isStaticKey: Bool {
		let pattern = "^[A-Z0-9_]*$"
		return self.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
	}

	/// Truncate string (cut it to a given number of characters).
	///
	///		var str = "This is a very long sentence"
	///		str.truncate(toLength: 14)
	///		print(str) // prints "This is a very..."
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string (default is "...").
	@discardableResult
	mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
		guard length > 0 else { return self }
		if self.count > length {
			self = self[self.startIndex..<self.index(self.startIndex, offsetBy: length)] + (trailing ?? "")
		}
		return self
	}

	/// Truncated string (limited to a given number of characters).
	///
	///		"This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
	///		"Short sentence".truncated(toLength: 14) -> "Short sentence"
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string.
	/// - Returns: truncated string (this is an extr...).
	func truncated(toLength length: Int, trailing: String? = "...") -> String {
		guard 1..<self.count ~= length else { return self }
		return self[self.startIndex..<self.index(self.startIndex, offsetBy: length)] + (trailing ?? "")
	}

	/// Return repaired string.
	var repaired: String {
		return self.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\"", with: "")
	}

}
