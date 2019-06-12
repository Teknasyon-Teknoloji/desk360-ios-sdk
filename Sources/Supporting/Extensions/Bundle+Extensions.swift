//
//  Bundle+Extensions.swift
//  Desk360
//
//  Created by samet on 31.05.2019.
//

extension Bundle {

	static var assetsBundle: Bundle? {
		let podBundle = Bundle(for: ListingView.self)
		guard let resourceBundleUrl = podBundle.url(forResource: "Desk360Assets", withExtension: "bundle") else { return nil }
		guard let resourceBundle = Bundle(url: resourceBundleUrl) else { return nil }
		return resourceBundle
	}

}
