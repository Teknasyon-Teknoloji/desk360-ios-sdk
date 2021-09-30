//
//  Desk360Properties.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 27.05.2021.
//

import Foundation

@objc open class Desk360Properties: NSObject {

    let appID: String
    let deviceID: String
    let environment: Desk360Environment
    let language: String
    let country: String
    let userCredentials: Desk360UserCredentials?
    let jsonInfo: [String: Any]?
    let timeZone = TimeZone.current.identifier
    let appPlatform = "iOS"
    let bypassCreateTicketIntro: Bool

    /// Creates a new instance of `Desk360Properties`
    /// - Parameters:
    ///   - appID: The Desk360 App ID.
    ///   - deviceID: The current device ID
    ///   - language: The current device language
    ///   - country: The current user country.
    ///   - userCredentials: The logged in user credentails. Provide it if you want the credntial fields to be filled automatically.
    ///   - bypassCreateTicketIntro: A flag used to hide the intro screen shown before creating a new ticket.
    ///   - jsonInfo: Any extra JSON data to be passed to the backend.
	@objc public init(
        appID: String,
        deviceID: String = UIDevice.current.uniqueIdentifier,
        environment: Desk360Environment = .production,
        language: String = Locale.current.languageCode ?? "en",
        country: String = Locale.current.regionCode?.uppercased() ?? "XX",
        userCredentials: Desk360UserCredentials? = nil,
        bypassCreateTicketIntro: Bool = false,
        jsonInfo: [String: Any]? = nil
    ) {
        self.appID = appID
        self.deviceID = deviceID
		self.environment = environment
        self.language = language
        self.country = country
		self.userCredentials = userCredentials
        self.bypassCreateTicketIntro = bypassCreateTicketIntro
		self.jsonInfo = jsonInfo
    }

}

/// Any user credentails.
@objc public class Desk360UserCredentials: NSObject {
	let name: String
	let email: String

	@objc public init(
		name: String,
		email: String
	) {
		self.name = name
		self.email = email
	}
}
