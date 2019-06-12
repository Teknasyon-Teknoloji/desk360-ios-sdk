//
//  Desk360NavigationController.swift
//  Desk360
//
//  Created by samet on 10.06.2019.
//

import UIKit

final class Desk360NavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationBar.setColors(background: Desk360.Config.currentTheme.backgroundColor, text: Desk360.Config.currentTheme.navItemTintColor)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		if Desk360.Config.theme == .dark {
			return .lightContent
		} else {
			return .default
		}

	}

}
