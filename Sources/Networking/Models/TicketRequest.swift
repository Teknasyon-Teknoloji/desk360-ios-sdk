//
//  TicketRequest.swift
//  Desk360
//
//  Created by samet on 20.05.2019.
//

import PersistenceKit

struct TicketRequest: Codable {

	var name: String
	var email: String
	var subject: String
	var message: String
	var type_id: String
	var source: String
	var platform: String
	var country_code: String

	init(
		name: String,
		email: String,
		subject: String,
		message: String,
		type_id: String,
		source: String,
		platform: String,
		country_code: String) {

		self.name = name
		self.email = email
		self.subject = subject
		self.message = message
		self.type_id = type_id
		self.source = source
		self.platform = platform
		self.country_code = country_code
	}

}
