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

	init(appId: String, deviceId: String, environment: Desk360Environment, language: String) {
		self.appId = appId
		self.deviceId = deviceId
		self.environment = environment.rawValue
		self.language = language
	}

}

extension RegisterModel: Codable {

	private enum CodingKeys: String, CodingKey {
		case appId
		case deviceId
		case environment
		case language
		case jsonInfo
	}

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	/// - Throws: Decoding error.
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		do {
			appId = try container.decode(String.self, forKey: .appId)
			deviceId = try container.decode(String.self, forKey: .deviceId)
			environment = try container.decode(String.self, forKey: .environment)
			language = try container.decode(String.self, forKey: .language)

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
			try container.encode(appId, forKey: .appId)
			try container.encode(deviceId, forKey: .deviceId)
			try container.encode(environment, forKey: .environment)
			try container.encodeIfPresent(language, forKey: .language)
		} catch let error as EncodingError {
			print(error)
			throw error
		}
	}

}

// MARK: - Identifiable
extension RegisterModel: Identifiable, Equatable {

	/// Id Type.
	public static var idKey = \RegisterModel.deviceId

}
