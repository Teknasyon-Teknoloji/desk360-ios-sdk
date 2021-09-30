//
//  Store.swift
//  Example
//
//  Created by samet on 13.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import PersistenceKit

/// Application data stores.
struct Stores {
	private init() {}

	static let deviceId = SingleUserDefaultsStore<String>(uniqueIdentifier: "device_id")!

	static let registerExpiredAt = SingleUserDefaultsStore<Date>(uniqueIdentifier: "register_expired_at")!

	static let currentLanguage = SingleUserDefaultsStore<Language>(uniqueIdentifier: "current_language")!

	static let environment = SingleUserDefaultsStore<String>(uniqueIdentifier: "environment")!

	static let useDeviceLanguage = SingleUserDefaultsStore<Bool>(uniqueIdentifier: "use_device_language")!

	static let useJsonData = SingleUserDefaultsStore<Bool>(uniqueIdentifier: "use_json_data")!

	static func setStoresInitialValues() {

		if registerExpiredAt.object == nil {
			try? registerExpiredAt.save(Date().addingTimeInterval(-24 * 3600))
		}

		if deviceId.object == nil {
			try? deviceId.save(generateRandomString())
		}

		if currentLanguage.object == nil {
			try? currentLanguage.save(Language.language(id: 1))
		}

		if environment.object == nil {
			try? environment.save("sandbox")
		}

		if useDeviceLanguage.object == nil {
			try? useDeviceLanguage.save(false)
		}

		if useJsonData.object == nil {
			try? useJsonData.save(false)
		}

	}

	static func generateRandomString(maxLength: Int = 32) -> String {
		let uuid = NSUUID().uuidString.prefix(maxLength)
		return String(uuid)
	}

}
