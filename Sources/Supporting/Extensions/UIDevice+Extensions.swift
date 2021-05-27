//
//  UIDevice+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import UIKit

extension UIDevice {

	public var uniqueIdentifier: String {
		return identifierForVendor!.uuidString
	}

}
