//
//  Field.swift
//  Desk360
//
//  Created by samet on 18.11.2019.
//



/// Use `SupportRequest` to map JSON objects returned from methods in `SupportService`
public struct Field {

	/// Request status.
	public enum FieldType: String, Codable {

		/// Request is expired, user can not add new messages.
		case input

		/// Request is open, user is waiting for a respose for their message.
		case selectbox

		/// User received a response and read it.
		case textarea

	}

	/// Id.
	public var id: Int?

	/// name.
	public var name: String?

	/// Status
	var type: FieldType?

	/// Options
	var options: [FieldOption]?

	/// Placeholder Text
	var placeholder: String?

}

extension Field: Codable {

//	public init(name: String, type: FieldType, placeholder: String, isRequired: Bool) {
//		self.name = name
//		self.type = type
//		self.isRequired = isRequired
//		self.placeholder = placeholder
//	}

	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case type
		case options
		case place_holder
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try (container.decodeIfPresent(Int.self, forKey: .id))
		name = try (container.decodeIfPresent(String.self, forKey: .name))
		type = try container.decodeIfPresent(FieldType.self, forKey: .type)
		options = try container.decodeIfPresent([FieldOption].self, forKey: .options)
		placeholder = try container.decodeIfPresent(String.self, forKey: .place_holder)


	}

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	/// - Throws: Encoding error.
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(name, forKey: .name)
		try container.encodeIfPresent(type, forKey: .type)
		try container.encodeIfPresent(options, forKey: .options)
		try container.encodeIfPresent(placeholder, forKey: .place_holder)
	}

}

/// Request status.
public struct FieldOption: Codable {

	var order: Int?

	var value: String?

}

