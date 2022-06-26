//
//  Bundle+Extensions.swift
//  Desk360
//
//  Created by samet on 31.05.2019.
//

import Foundation

extension Bundle {

	static var assetsBundle: Bundle? {
		let podBundle = Bundle(for: ListingView.self)
		guard let resourceBundleUrl = podBundle.url(forResource: "Desk360Assets", withExtension: "bundle") else { return nil }
		guard let resourceBundle = Bundle(url: resourceBundleUrl) else { return nil }
		return resourceBundle
	}

	static var localizedBundle: Bundle? {
		let bundle = Bundle(for: ListingView.self)
		guard let path = bundle.path(forResource: "Desk360", ofType: "bundle") else { return nil }
		guard let localizedBundle = Bundle(path: path) else { return nil }
		return localizedBundle
	}
    
    static var fontsBundle: Bundle? {
        let bundle = Bundle(for: Desk360.self)
        guard let path = bundle.path(forResource: "Desk360Fonts", ofType: "bundle") else { return nil }
        guard let localizedBundle = Bundle(path: path) else { return nil }
        return localizedBundle
    }

	static var base: Bundle? {
		let bundle = Bundle(identifier: "test")
		guard let resourceBundleUrl = bundle?.url(forResource: "Desk360", withExtension: "lproj") else { return nil }
		guard let resourceBundle = Bundle(url: resourceBundleUrl) else { return nil }
		return resourceBundle
	}

}
