//
//  NewMessage.swift
//  Alamofire
//
//  Created by samet on 21.05.2019.
//

//import PersistenceKit

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct NewMessage {

	/// Message.
	public var message: String

}

extension NewMessage: Codable {

	private enum CodingKeys: String, CodingKey {
		case message
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		message = try container.decode(String.self, forKey: .message)
	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(message, forKey: .message)
	}

}

// MARK: - Identifiable
extension NewMessage: Identifiable, Equatable {

	/// Id Type.
	public static var idKey = \NewMessage.message

}
