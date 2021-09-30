//
//  Language.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import Foundation

struct Language: Codable {

	var id: Int
	var name: String
	var code: String
	var country_code: String

}

// MARK: - Helpers
extension Language {

	static func language(id: Int) -> Language? {
		let currentLanguage = languages().filter({$0.id == id})
		return currentLanguage.first
	}

	static func languages() -> [Language] {
		guard let path = Bundle.main.path(forResource: "languages", ofType: "json") else { return [] }
		let url = URL(fileURLWithPath: path)
		guard let json = try? Data(contentsOf: url) else { return [] }
		return (try? JSONDecoder().decode([Language].self, from: json)) ?? []
	}

}
