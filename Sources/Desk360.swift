//
//  Desk360.swift
//  Desk360
//
//  Created by Omar on 5/7/19.
//

import UIKit
import Moya
import Alamofire
import Foundation

private var desk: Desk360?

public final class Desk360 {

	private(set) public static var appId: String!

	private(set) public static var deviceId: String!

	private(set) public static var timeZone: String!

	private(set) public static var appPlatform: String!

	private(set) public static var appVersion: String!

	private(set) public static var languageCode: String!

	private(set) public static var isDebug: Bool!

	static var token: String? = ""

	static let authPlugin = AccessTokenPlugin { Desk360.token ?? "" }

	static let apiProvider = MoyaProvider<Service>(plugins: [authPlugin])

	static var isRegister = false

	/// Whether internet is reachable or not.
	static var isReachable: Bool {
		return NetworkReachabilityManager()?.isReachable ?? false
	}

	public init(appId: String, deviceId: String, isDebug: Bool, language: String) {
		Desk360.appId = appId
		Desk360.deviceId = deviceId
		Desk360.appPlatform = "iOS"
		Desk360.appVersion = getVersion()
		Desk360.timeZone = TimeZone.current.identifier
		Desk360.languageCode = language
		Desk360.isDebug = isDebug
	}

	func getVersion() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return "0.0.0"
		}
		return version
	}

	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:) before using the SDK")
		}
		return aDesk
	}

	public static func start(appId: String, deviceId: String? = nil, isDebug: Bool? = false, language: String? = nil) {
		var id: String = ""
		if deviceId == nil {
			id = UIDevice.current.uniqueIdentifier
		} else {
			id = deviceId ?? ""
		}
		var currentLanguage = "en"
		if language == nil {
			currentLanguage = Locale.current.languageCode ?? "en"
		} else {
			currentLanguage = language ?? "en"
		}
		desk = Desk360(appId: appId, deviceId: id, isDebug: isDebug ?? false, language: currentLanguage)
		Stores.setStoresInitialValues()
		print("Desk360 SDK was initialized successfully!")
	}

	public static func show(on viewController: UIViewController, animated: Bool = true) {
		guard let navController = viewController.navigationController else {
			fatalError("Unable to push Desk360 because \(viewController.self) is not embedded in UINavigationController.")
		}
		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
		desk360Navcontroller.modalPresentationStyle = .fullScreen
		navController.present(desk360Navcontroller, animated: true, completion: nil)
	}

}
