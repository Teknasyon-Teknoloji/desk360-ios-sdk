//
//  NavigationItems.swift
//  Desk360
//
//  Created by samet on 22.05.2019.
//

import UIKit

struct NavigationItems {

	static func back(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon"), style: .plain, target: target, action: action)
	}

	static func add(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavigationbarAdd"), style: .plain, target: target, action: action)
	}

	static func edit(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavigationbarEdit"), style: .plain, target: target, action: action)
	}

	static func close(target: Any?, action: Selector?) -> UIBarButtonItem {
		return UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavigationbarClose"), style: .plain, target: target, action: action)
	}

	static func save(target: Any?, action: Selector?, title: String?) -> UIBarButtonItem {
		return UIBarButtonItem(title: title, style: .plain, target: target, action: action)
	}

}
