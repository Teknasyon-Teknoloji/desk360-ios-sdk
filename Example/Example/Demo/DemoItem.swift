//
//  DemoItem.swift
//  Example
//
//  Created by samet on 16.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

enum Environment: String {
	case test
	case production
}

enum DemoItem: CaseIterable {

	case environment
	case useJsonData
	case jsonData
	case useDeviceLanguage
	case language
	case rightAppId

	init?(indexPath: IndexPath) {
		guard let item = DemoItem.allCases.first(where: { $0.indexPath == indexPath }) else { return nil }
		self = item
	}

}

// MARK: - Helpers
extension DemoItem {

	var isSwitch: Bool {
		switch self {
		case .useDeviceLanguage, .useJsonData, .rightAppId:
			return true
		default:
			return false
		}
	}

	var isSegmentedControl: Bool {
		switch self {
		case .environment:
			return true
		default:
			return false
		}
	}

	var isDescription: Bool {
		switch self {
		case .environment:
			return true
		default:
			return true
		}
	}

	var description: String? {
		switch self {
		case .environment:
			let environment = Stores.environment.object
			return environment == "test" ? "Test" : "Production"
		default:
			return ""
		}
	}

	var title: String? {
		switch self {
		case .environment:
			return "Environment"
		case .jsonData:
			return "Json Data"
		case .language:
			return "Language"
		case .rightAppId:
			return "Right App Id"
		case .useDeviceLanguage:
			return "Use Device Language"
		case .useJsonData:
			return "Use Json info"
		}
	}

	var indexPath: IndexPath {
		switch self {
		case .environment:
			return IndexPath(row: 0, section: 0)
		case .useJsonData:
			return IndexPath(row: 1, section: 0)
		case .jsonData:
			return IndexPath(row: 2, section: 0)
		case .useDeviceLanguage:
			return IndexPath(row: 3, section: 0)
		case .language:
			return IndexPath(row: 4, section: 0)
		case .rightAppId:
			return IndexPath(row: 5, section: 0)

		}
	}

}
