//
//  DeskTicketCreateRequest.swift
//  Desk360
//
//  Created by Omar on 5/8/19.
//

import Foundation

public struct DeskTicketCreateRequest {

	var name: String
	var email: String
	var subject: String
	var message: String

}

extension DeskTicketCreateRequest: Encodable {

	private enum CodingKeys: String, CodingKey {
		case name
		case email
		case subject
		case message
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(name, forKey: .name)
		try container.encode(email, forKey: .email)
		try container.encode(subject, forKey: .subject)
		try container.encode(message, forKey: .message)
	}

}
