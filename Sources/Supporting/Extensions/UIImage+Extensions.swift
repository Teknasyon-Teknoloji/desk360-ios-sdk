//
//  UIImage+Extensions.swift
//  Desk360
//
//  Created by samet on 31.05.2019.
//

import UIKit

public extension UIImage {

	convenience init?(fromAssets name: String, type: String = "png") {
		guard let bundle = Bundle.assetsBundle else { return nil }
		guard let path = bundle.path(forResource: "Images" + "\(name)", ofType: type) else { return nil }
		self.init(contentsOfFile: path)
	}

}
