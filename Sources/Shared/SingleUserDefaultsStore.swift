//
//  SingleUserDefaultsStore.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

/// `SingleUserDefaultsStore` offers a convenient way to store a single `Codable` object in `UserDefaults`.
final class SingleUserDefaultsStore<T: Codable> {

	/// Store's unique identifier.
	///
	/// **Warning**: Never use the same identifier for two -or more- different stores.
	let uniqueIdentifier: String

	/// JSON encoder. _default is `JSONEncoder()`_
	var encoder = JSONEncoder()

	/// JSON decoder. _default is `JSONDecoder()`_
	var decoder = JSONDecoder()

	/// UserDefaults store.
	private var store: UserDefaults

	/// Initialize store with given identifier.
	///
	/// **Warning**: Never use the same identifier for two -or more- different stores.
	///
	/// - Parameter uniqueIdentifier: store's unique identifier.
	required init?(uniqueIdentifier: String) {
		guard let store = UserDefaults(suiteName: uniqueIdentifier) else { return nil }
		self.uniqueIdentifier = uniqueIdentifier
		self.store = store
	}

	/// Save object to store. _O(1)_
	///
	/// - Parameter object: object to save.
	/// - Throws: JSON encoding error.
	func save(_ object: T) throws {
		let data = try encoder.encode(generateDict(for: object))
		store.set(data, forKey: key)
	}

	/// Save an optional object to store. _O(1)_
	///
	/// - Parameter object: object to save.
	/// - Throws: JSON encoding error.
	func save(_ object: T?) throws {
		guard let anObject = object else {
			delete()
			return
		}
		try save(anObject)
	}

	/// Get object from store. _O(1)_
	var object: T? {
		guard let data = store.data(forKey: key) else { return nil }
		guard let dict = try? decoder.decode([String: T].self, from: data) else { return nil }
		return extractObject(from: dict)
	}

	/// Delete object from store. _O(1)_
	func delete() {
		store.set(nil, forKey: key)
		store.removeSuite(named: uniqueIdentifier)
	}

}

// MARK: - Helpers
private extension SingleUserDefaultsStore {

	/// Enclose the object in a dictionary to enable single object storing.
	///
	/// - Parameter object: object.
	/// - Returns: dictionary enclosing object.
	func generateDict(for object: T) -> [String: T] {
		return ["object": object]
	}

	/// Extract object from dictionary.
	///
	/// - Parameter dict: dictionary.
	/// - Returns: object.
	func extractObject(from dict: [String: T]) -> T? {
		return dict["object"]
	}

	/// Store key for object.
	var key: String {
		return "\(uniqueIdentifier)-single-object"
	}

}
