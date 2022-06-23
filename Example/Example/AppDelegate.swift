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

        guard let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNav") as? UINavigationController else { return true }


        Stores.setStoresInitialValues()
//		Desk360.start(appId: "123456")
        window = UIWindow()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }

}
