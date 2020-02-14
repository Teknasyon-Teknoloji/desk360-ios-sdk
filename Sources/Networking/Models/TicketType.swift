//
//  TicketType.swift
//  Desk360
//
//  Created by samet on 21.05.2019.
//

//import PersistenceKit

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct TicketType {

	/// Id.
	public var id: Int

	/// Message.
	public var title: String

}

extension TicketType: Codable {

	private enum CodingKeys: String, CodingKey {
		case id
		case title
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try container.decode(Int.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
	}

}

// MARK: - Identifiable
extension TicketType: Identifiable, Equatable {

	/// Id Type.
	public static var idKey = \TicketType.id

}
