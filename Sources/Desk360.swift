//
//  Desk360.swift
//  Desk360
//
//  Created by Omar on 5/7/19.
//

import Foundation

private var desk: Desk360?

public final class Desk360 {

	private(set) public var appId: String!

	var token: String?

	public init(appId: String) {
		self.appId = appId
	}

	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:) before using the SDK")
		}
		return aDesk
	}

	public static func start(appId: String) {
		desk = Desk360(appId: appId)
		print("Desk360 SDK was initialized successfully!")
	}

	public static func push(on viewController: UIViewController, animated: Bool = true) {
		guard let navController = viewController.navigationController else {
			fatalError("Unable to push Desk360 because \(viewController.self) is not embedded in UINavigationController.")
		}
		navController.pushViewController(ListingViewController(), animated: animated)
	}

	public static func present(in viewController: UIViewController, animated: Bool = true) {
		let navController = UINavigationController(rootViewController: ListingViewController())
		viewController.present(navController, animated: animated)
	}

}
