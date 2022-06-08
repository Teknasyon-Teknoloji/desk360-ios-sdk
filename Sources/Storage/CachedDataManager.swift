//
//  CashedDataManager.swift
//  Desk360
//
//  Created by samet on 3.03.2020.
//

import Moya
import PersistenceKit
import Foundation

final class CachedDataManager: NSObject {

	static let shared = CachedDataManager()

	var config = Stores.configStore.object

	func updateConfig(_ newModel: ConfigModel) {
//		Config.shared.model = newModel
	}

}
