//
//  Store.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

//import PersistenceKit

/// Application data stores.
struct Stores {
	private init() {}

	static let ticketsStore = UserDefaultsStore<Ticket>(uniqueIdentifier: "support_tickets")!

	static let tokenStore = SingleUserDefaultsStore<String>(uniqueIdentifier: "access_token")!

	static let ticketTypeStore = UserDefaultsStore<TicketType>(uniqueIdentifier: "support_tickets")!

	static let registerExpiredAt = SingleUserDefaultsStore<Date>(uniqueIdentifier: "register_expired_at")!

	static let registerModel = SingleUserDefaultsStore<RegisterModel>(uniqueIdentifier: "register_model")!

	static let userName = SingleUserDefaultsStore<String>(uniqueIdentifier: "user_name")!

	static let userMail = SingleUserDefaultsStore<String>(uniqueIdentifier: "user_mail")!

	static func setStoresInitialValues() {

		if registerExpiredAt.object == nil {
			try? registerExpiredAt.save(Date())
		}

	}

}
