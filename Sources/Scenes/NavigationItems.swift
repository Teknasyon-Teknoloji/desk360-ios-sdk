//
//  NavigationItems.swift
//  Desk360
//
//  Created by samet on 22.05.2019.
//

import UIKit

struct NavigationItems {

	static func add(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: Desk360.Config.Requests.Listing.NavItem.addIcon, style: .plain, target: target, action: action)
	}

	static func close(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: Desk360.Config.Requests.Listing.NavItem.closeIcon, style: .plain, target: target, action: action)
	}

	static func back(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: Desk360.Config.Requests.Listing.NavItem.backIcon, style: .plain, target: target, action: action)
	}

}
