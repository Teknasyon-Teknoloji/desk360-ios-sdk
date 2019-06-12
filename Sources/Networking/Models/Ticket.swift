//
//  Ticket.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import PersistenceKit

/// Use `SupportRequest` to map JSON objects returned from methods in `SupportService`
public struct Ticket {

	/// Request status.
	public enum Status: String, Codable {

		/// Request is expired, user can not add new messages.
		case expired

		/// Request is open, user is waiting for a respose for their message.
		case open

		/// User received a response and read it.
		case read

		/// User received a response but did not read it.
		case unread

	}

	/// Id.
	public var id: Int

	/// Name.
	public var name: String

	/// Email
	public var email: String

	/// Subject
	public var subject: String

	/// Status
	var status: Status

	/// Date the request was created.
	public var createdAt: Date

	/// Array of conversation `SupportMessage`s.
	public var messages: [Message]

}

extension Ticket: Codable {

	private enum CodingKeys: String, CodingKey {
		case id
		case status
		case name
		case email
		case subject
		case created
		case messages
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

			id = try container.decode(Int.self, forKey: .id)
			name = try container.decode(String.self, forKey: .name)
			email = try container.decode(String.self, forKey: .email)
			subject = try container.decode(String.self, forKey: .subject)

			status = try container.decode(Status.self, forKey: .status)

			let dateString = try container.decode(String.self, forKey: .created)

			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

			createdAt = formatter.date(from: dateString)!

			messages = (try? container.decodeIfPresent([Message].self, forKey: .messages) ?? []) ?? []
	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

			try container.encode(id, forKey: .id)
			try container.encode(name, forKey: .name)
			try container.encode(email, forKey: .email)
			try container.encode(subject, forKey: .subject)

			try container.encode(status, forKey: .status)

			try container.encode(createdAt, forKey: .created)
			try container.encode(messages, forKey: .messages)
	}

}

extension Ticket: Comparable {

	public static func < (lhs: Ticket, rhs: Ticket) -> Bool {
		return lhs.createdAt > rhs.createdAt
	}

}

extension Ticket: Identifiable, Equatable {

	public static func == (lhs: Ticket, rhs: Ticket) -> Bool {
		return lhs.id == rhs.id
	}

	/// Id Type.
	public static var idKey = \Ticket.id

}