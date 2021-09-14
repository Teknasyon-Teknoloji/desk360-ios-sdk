//
//  RegisterModel.swift
//  Desk360
//
//  Created by samet on 23.01.2020.
//

import Foundation
import PersistenceKit

public struct RegisterModel {

	var appId: String
	var deviceId: String
	var environment: String
	var language: String
    var country: String

	init(
        appId: String,
        deviceId: String,
        environment: Desk360Environment,
        language: String,
        country: String
    ) {
        self.appId = appId
        self.deviceId = deviceId
		self.environment = environment.stringValue
        self.language = language
        self.country = country
	}
}

extension RegisterModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case appId
		case deviceId
		case environment
		case language
        case country
	}

}

// MARK: - Identifiable
extension RegisterModel: Identifiable, Equatable {

	/// Id Type.
	public static var idKey = \RegisterModel.deviceId

}
