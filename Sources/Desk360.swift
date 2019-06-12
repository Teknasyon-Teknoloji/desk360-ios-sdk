//
//  Desk360.swift
//  Desk360
//
//  Created by Omar on 5/7/19.
//

import UIKit
import Moya

private var desk: Desk360?

public final class Desk360 {

	private(set) public static var appId: String!

	static var token: String? = ""

	static let authPlugin = AccessTokenPlugin { Desk360.token ?? "" }
	static let apiProvider = MoyaProvider<Service>(plugins: [authPlugin])

	public init(appId: String) {
		Desk360.appId = appId
	}

	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:) before using the SDK")
		}
		return aDesk
	}

	public static func start(appId: String) {
		desk = Desk360(appId: appId)
		Stores.setStoresInitialValues()
		Desk360.register()
		print("Desk360 SDK was initialized successfully!")
	}

	public static func show(on viewController: UIViewController, animated: Bool = true) {
		guard let navController = viewController.navigationController else {
			fatalError("Unable to push Desk360 because \(viewController.self) is not embedded in UINavigationController.")
		}
		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = Desk360NavigationController(rootViewController: listingViewController)
		navController.present(desk360Navcontroller, animated: true, completion: nil)
	}

	static func register() {

		guard let date = Stores.registerExpiredAt.object else { return }
		guard date < Date() else { return }

		Desk360.apiProvider.request(.register(appKey: Desk360.appId)) {  result in
			switch result {
			case .failure:
				print("error")
			case .success(let response):
				guard let register = try? response.map(DataResponse<RegisterRequest>.self) else { return }
				Desk360.token = register.data?.accessToken

				try? Stores.registerExpiredAt.save(register.data?.expiredDate)
			}
		}
	}

}
