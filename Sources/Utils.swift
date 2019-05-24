//
//  Utils.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

/// Common Desk360 utilities
final class Utils {
	private init() {}

	/// Generate a random string based on `NSUUID.uuidString`
	///
	/// - Parameter maxLength: max length for the string _default value is 32_
	/// - Returns: secret string.
	static func generateRandomString(maxLength: Int = 32) -> String {
		let uuid = NSUUID().uuidString.prefix(maxLength)
		return String(uuid)
	}

	/// Generate JSON string from an object.
	///
	/// - Parameter object: Any object.
	/// - Returns: JSON representation of given object.
	static func jsonString(from object: Any?) -> String? {
		guard let anObject = object else { return nil }
		if !JSONSerialization.isValidJSONObject(anObject) {
			return String(describing: anObject)
		}
		guard let data = try? JSONSerialization.data(withJSONObject: anObject, options: .prettyPrinted) else { return nil }
		return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\"", with: "")
	}

//	/// Return repaired string.
//	var repaired: String {
//		return base.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\"", with: "")
//	}

}
