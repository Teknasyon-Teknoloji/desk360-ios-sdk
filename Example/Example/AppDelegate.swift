//
//  AppDelegate.swift
//  Example
//
//  Created by Omar on 5/9/19.
//  Copyright © 2019 Teknasyon. All rights reserved.
//

import UIKit
import Desk360

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		Stores.setStoresInitialValues()
//		Desk360.start(appId: "123456")
		window = UIWindow()
		window?.rootViewController = UINavigationController(rootViewController: DemoViewController())
		window?.makeKeyAndVisible()

		return true
	}

}
