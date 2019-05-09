//
//  DeskConfig+Stores.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

extension Desk360.Config {

	struct Stores {
		private init() {}

		static let backgroundColor = SingleUserDefaultsStore<String>(uniqueIdentifier: "desk360_background_color")
		static let textColor = SingleUserDefaultsStore<String>(uniqueIdentifier: "desk360_text_color")

	}

}
