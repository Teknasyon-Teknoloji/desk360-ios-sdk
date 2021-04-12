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
import Photos

private var desk: Desk360?

public enum Desk360Environment: String {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
	case test
    
    case sandbox
	case production
}

public final class Desk360 {

	private(set) public static var appId: String!

	private(set) public static var deviceId: String!

	private(set) public static var timeZone: String!

	private(set) public static var appPlatform: String!

	private(set) public static var appVersion: String!
    
    private(set) public static var sdkVersion: String!

	private(set) public static var languageCode: String!
    
    private(set) public static var countryCode: String!

	private(set) public static var isDebug: Bool!

	private(set) public static var environment: Desk360Environment!

	private(set) public static var jsonInfo: [String: Any]!

	private(set) public static var pushToken: String?

	public static var messageId: Int?

    static var list: ListingViewController?
    
    static var conVC: ConversationViewController?
    
    static var thanksVC: SuccsessViewController?
    
	static var isActive: Bool = false

	static var token: String? = ""

	static let authPlugin = AccessTokenPlugin { Desk360.token ?? "" }

	static let apiProvider = MoyaProvider<Service>(plugins: [authPlugin])

	static var isRegister = false

	static var applaunchChecker = false

	static var didTapNotification = false

	/// Whether internet is reachable or not.
	static var isReachable: Bool {
		return NetworkReachabilityManager()?.isReachable ?? false
	}

    public init(appId: String, deviceId: String, environment: Desk360Environment, language: String, country: String , jsonInfo: [String: Any]) {
		Desk360.appId = appId
		Desk360.deviceId = deviceId
		Desk360.appPlatform = "iOS"
		Desk360.appVersion = getAppVersion()
        Desk360.sdkVersion = getSdkVersion()
		Desk360.timeZone = TimeZone.current.identifier
		Desk360.languageCode = language
        Desk360.countryCode = country
		Desk360.environment = environment
		Desk360.jsonInfo = jsonInfo
	}

	private func getAppVersion() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return "0.0.0"
		}
		return version
	}
    
    private func getSdkVersion() -> String {
        guard let version = Bundle(for: Self.self).infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "0.0.0"
        }
        return version
    }
    
    static func fetchTicketList() {
        guard list != nil else { return }
        list?.fetchList()
    }
    
	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:) before using the SDK")
		}
		return aDesk
	}

	public static func setPushToken(deviceToken: Data? = nil) {
		guard let token = deviceToken else { return }
		let tokenString = token.reduce("", {$0 + String(format: "%02X", $1)})
		self.pushToken = tokenString
		print("pushToken: \(String(describing: pushToken))")
	}

	public static func applicationLaunchChecker(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] else { return }
        guard let data = remoteNotif["data"] as? [String: AnyObject] else { return }
		guard let id = userInfoHandle(data) else { return }
		Desk360.didTapNotification = true
		Desk360.applaunchChecker = true
		Desk360.messageId = id
    }

    public static func willNotificationPresent(_ userInfo: [AnyHashable: Any]?) {

        if Desk360.conVC != nil {
            guard let data = userInfo?["data"] as? [String: AnyObject] else { return }
            guard let id = userInfoHandle(data) else { return }
            if let req = Desk360.conVC?.request {
                if req.id == id {
                    Desk360.conVC?.refreshAction()
                    return
                }
            }
        }
        if Desk360.list != nil {
            Desk360.list?.fetchList()
            return
        }
    }
    
	public static func applicationUserInfoChecker(_ userInfo: [AnyHashable: Any]?) {
        
		guard !Desk360.applaunchChecker else {
			Desk360.applaunchChecker = false
			return
		}
		if #available(iOS 13.0, *), Desk360.didTapNotification { return }
        Desk360.didTapNotification = false
		if Desk360.messageId != nil { Desk360.messageId = nil }
		guard let data = userInfo?["data"] as? [String: AnyObject] else { return }
		guard let id = userInfoHandle(data) else { return }
        
        if Desk360.conVC != nil {
            if let req = Desk360.conVC?.request {
                if req.id == id {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        Desk360.conVC?.refreshAction()
                    }
                    return
                }
            }
        }
        
		guard Desk360.isActive == false else {
			Desk360.messageId = id
            
            guard let list = Desk360.list else { return }
            list.navigationController?.popToRootViewController(animated: false)
            guard let ticket = list.requests.first(where: {$0.id == id}) else { return }
            let viewController = ConversationViewController(request: ticket)
            viewController.hidesBottomBarWhenPushed = true
            list.navigationController?.pushViewController(viewController, animated: false)
            Desk360.messageId = nil
            Desk360.didTapNotification = false
            
			return
		}
		Desk360.messageId = id
        guard let topVC = topViewController else { return }
		showWithPushDeeplink(on: topVC, animated: true)
	}

	static func userInfoHandle(_ data: [String: AnyObject]) -> Int? {
		guard let hermes = data["hermes"] as? [String: AnyObject] else { return nil }
		guard let detail = hermes["target_detail"] as? [String: AnyObject] else { return nil }
		guard let categoryId = detail["target_category"] as? String else { return nil }
		guard categoryId == "Desk360Deeplink" else { return nil }
		guard let id = detail["target_id"] as? String else { return nil }
		return Int(id)
	}

	static func checkIsActiveDesk360(_ navigationController: UINavigationController) {

        guard let listingViewController = navigationController.children.first as? ListingViewController else { return }
        let tickets = listingViewController.requests
        let id = Desk360.messageId
        Desk360.messageId = nil
        Desk360.didTapNotification = false
        var ticket: Ticket?
        for tic in tickets where tic.id == id {
            ticket = tic
        }
        guard ticket != nil else { return }
        if let vc = Desk360.conVC {
            vc.readRequest(ticket!)
            return
        }
        if let convc = navigationController.viewControllers.last as? ConversationViewController {
            convc.readRequest(ticket!)
            return
        } else {
            guard navigationController.children.count <= 1 else {
                navigationController.popToRootViewController(animated: false)
                return
            }
            let viewController = ConversationViewController(request: ticket!)
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: false)
        }
	}

	public static func showWithPushDeeplink(on viewController: UIViewController, animated: Bool = false) {

		guard Desk360.messageId != nil else { return }
		guard let registerModel = Stores.registerModel.object else { return }

        desk = Desk360(appId: registerModel.appId, deviceId: registerModel.deviceId, environment: Desk360Environment(rawValue: registerModel.environment) ?? .production, language: registerModel.language, country: registerModel.country, jsonInfo: [:])

		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
		desk360Navcontroller.modalPresentationStyle = .fullScreen
		viewController.present(desk360Navcontroller, animated: true, completion: nil)

	}

	static var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }

    public static func start(
        appId: String,
        userName: String? = nil,
        userEmail: String? = nil,
        deviceId: String? = nil,
        environment: Desk360Environment? = .production,
        language: String? = nil,
        country: String? = nil,
        jsonInfo: [String: Any]? = [:]
    ) {
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
        var currentCountry: String
        if let country = country {
            currentCountry = country
        } else {
            currentCountry = Locale.current.regionCode?.uppercased() ?? "XX"
        }
		
        var currentEnvironment: Desk360Environment = .production
		if environment != nil {
			currentEnvironment = environment ?? .production
		}
        
        try? Stores.userName.save(userName)
        try? Stores.userMail.save(userEmail)
        
		isActive = true
        desk = Desk360(appId: appId, deviceId: id, environment: currentEnvironment, language: currentLanguage, country: currentCountry, jsonInfo: jsonInfo ?? [:])

        let registerModel = RegisterModel(appId: appId, deviceId: id, environment: currentEnvironment, language: currentLanguage, country: currentCountry)
		try? Stores.registerModel.save(registerModel)
        
		Stores.setStoresInitialValues()
		print("Desk360 SDK was initialized successfully!")
	}

	public static func show(on viewController: UIViewController, animated: Bool = true) {
		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
		desk360Navcontroller.modalPresentationStyle = .fullScreen
		viewController.present(desk360Navcontroller, animated: true, completion: nil)
	}

    static func isUrlLocal( _ url: URL) -> Bool {
        return !url.absoluteString.hasPrefix("https://")
    }
}
