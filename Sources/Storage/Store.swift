//
//  Store.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import PersistenceKit

/// Application data stores.
struct Stores {
	private init() {}

	static let ticketsStore = UserDefaultsStore<Ticket>(uniqueIdentifier: "desk360_support_tickets")!

	static let ticketWithMessageStore = UserDefaultsStore<Ticket>(uniqueIdentifier: "desk360_support_tickets_with_message")!

	static let tokenStore = SingleUserDefaultsStore<String>(uniqueIdentifier: "access_token")!

	static let registerExpiredAt = SingleUserDefaultsStore<Date>(uniqueIdentifier: "register_expired_at")!

	static let registerModel = SingleUserDefaultsStore<RegisterModel>(uniqueIdentifier: "register_model")!

	static let userName = SingleUserDefaultsStore<String>(uniqueIdentifier: "user_name")!

	static let userMail = SingleUserDefaultsStore<String>(uniqueIdentifier: "user_mail")!

	static let configStore = SingleUserDefaultsStore<ConfigModel>(uniqueIdentifier: "config_model")!

	static let registerCacheModel = SingleUserDefaultsStore<RegisterModel>(uniqueIdentifier: "register_cache_model")!

	static func setStoresInitialValues() {

		if registerExpiredAt.object == nil {
			try? registerExpiredAt.save(Date().addingTimeInterval(-24 * 3600))
		}

	}

}

