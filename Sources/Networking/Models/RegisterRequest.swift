//
//  Register.swift
//  Desk360
//
//  Created by samet on 20.05.2019.
//

//import PersistenceKit

struct RegisterRequest {

	var accessToken: String

	var tokenType: String

	var expiredAt: String?

	var expiredDate: Date?

}

extension RegisterRequest: Codable {

	private enum CodingKeys: String, CodingKey {
		case access_token
		case expired_at
		case token_type
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		accessToken = try container.decode(String.self, forKey: .access_token)
		tokenType = try container.decode(String.self, forKey: .token_type)
		expiredAt = try? container.decodeIfPresent(String.self, forKey: .expired_at)

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

		expiredDate = formatter.date(from: expiredAt ?? "1970-01-01 00:00:00")

	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(accessToken, forKey: .access_token)
		try container.encode(tokenType, forKey: .token_type)
		try container.encodeIfPresent(expiredAt, forKey: .expired_at)
	}

}

// MARK: - Identifiable
extension RegisterRequest: Identifiable, Equatable {

	/// Id Type.
	public static var idKey = \RegisterRequest.accessToken

}
