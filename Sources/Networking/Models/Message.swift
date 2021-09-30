//
//  Message.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import PersistenceKit

/// Use `SupportMessage` to map JSON object returned from the methods in `SupportService`
public struct Message {

	/// Id.
	public var id: Int

	/// Message.
	public var message: String

	/// Whether the message was sent by user or not.
	public var isAnswer: Bool

	/// Date string when the message was created.
	public var createdAt: String?

    /// message attachments.
    public var attachments: Attachment?

}

extension Message: Codable {

	private enum CodingKeys: String, CodingKey {
		case id
		case message
		case is_answer
		case created
        case attachments
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			id = try container.decode(Int.self, forKey: .id)
			message = try container.decode(String.self, forKey: .message)
			isAnswer = try container.decode(Bool.self, forKey: .is_answer)
			createdAt = (try? container.decodeIfPresent(String.self, forKey: .created)) ?? nil
            attachments = try? container.decodeIfPresent(Attachment.self, forKey: .attachments)
		} catch let error as DecodingError {
			print(error)
			throw error
		}
	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		do {
			try container.encode(id, forKey: .id)
			try container.encode(message, forKey: .message)
			try container.encode(isAnswer, forKey: .is_answer)
			try container.encodeIfPresent(createdAt, forKey: .created)
            try container.encodeIfPresent(attachments, forKey: .attachments)
		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}

// MARK: - Identifiable
extension Message: Identifiable, Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    /// Id Type.
    public static var idKey = \Message.id

}
