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

public enum Desk360Environment: String, Equatable {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
    case test
    
    case sandbox
    case production
}

public final class Desk360 {
    
    private(set) public static var properties: Desk360Properties?
	private(set) public static var pushToken: String?
    private(set) public static var appVersion: String = "0.0.0"
    private(set) public static var sdkVersion: String = "0.0.0"
    
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
    
    @available(*, deprecated, renamed: "init(properties:)", message: "Deprecated and will be removed in the future versions")
    public init(appId: String, deviceId: String, environment: Desk360Environment, language: String, country: String , jsonInfo: [String: Any]) {
        let props = Desk360Properties(appID: appId, deviceID: deviceId, environment: environment, language: language, country: country, userCredentials: nil, jsonInfo: jsonInfo)
        Desk360.properties = props
        Desk360.appVersion = getAppVersion()
        Desk360.sdkVersion = getSdkVersion()
	}
    
    /// Creates DESK360 instance configured with the given properties.
    /// - Parameter properties: DESK360 configuration properties.
    public init(properties: Desk360Properties) {
        Desk360.properties = properties
        Desk360.appVersion = getAppVersion()
        Desk360.sdkVersion = getSdkVersion()
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
        Desk360.messageId = id
        
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
            guard let list = Desk360.list else {
                showWithPushDeeplink(on: topViewController, animated: true)
                return
            }
            
            list.navigationController?.popToRootViewController(animated: false)
            guard let ticket = list.requests.first(where: {$0.id == id}) else { return }
            let viewController = ConversationViewController(request: ticket)
            viewController.hidesBottomBarWhenPushed = true
            list.navigationController?.pushViewController(viewController, animated: false)
            Desk360.messageId = nil
            Desk360.didTapNotification = false
			return
		}
    
        guard let topVC = topViewController else { return }
		showWithPushDeeplink(on: topVC, animated: true)
	}

	public static func showWithPushDeeplink(on viewController: UIViewController?, animated: Bool = false) {

		guard Desk360.messageId != nil, let viewController = viewController else { return }
		guard let registerModel = Stores.registerModel.object else { return }
        let properties = Desk360Properties(
            appID: registerModel.appId,
            deviceID: registerModel.deviceId,
            environment: Desk360Environment(rawValue: registerModel.environment) ?? .production,
            language: registerModel.language,
            country: registerModel.country
        )
        
        desk = Desk360(properties: properties)

		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
		desk360Navcontroller.modalPresentationStyle = .fullScreen
		viewController.present(desk360Navcontroller, animated: true, completion: nil)
        Desk360.messageId = nil
	}

    @available(iOS, deprecated, renamed: "start(properties:)", message: "This method will be removed in the next versions")
    public static func start(
        appId: String,
        deviceId: String? = nil,
        environment: Desk360Environment? = .production,
        language: String? = nil,
        country: String? = nil,
        userName: String? = nil,
        userEmail: String? = nil,
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
        
        var cred: Desk360Properties.Credentials?
        if let name = userName, let email = userEmail {
            cred = Desk360Properties.Credentials.init(name: name, email: email)
        }
        
        let properties = Desk360Properties(appID: appId, deviceID: id, environment: environment ?? .production, language: currentLanguage, country: currentCountry, userCredentials: cred, jsonInfo: jsonInfo)
        
        desk = Desk360(properties: properties)

        let registerModel = RegisterModel(
            appId: appId,
            deviceId: id,
            environment: currentEnvironment,
            language: currentLanguage,
            country: currentCountry
        )
        
		try? Stores.registerModel.save(registerModel)
        
		Stores.setStoresInitialValues()
		print("Desk360 SDK was initialized successfully!")
	}

    public static func start(using properties: Desk360Properties) {
        try? Stores.userName.save(properties.userCredentials?.name)
        try? Stores.userMail.save(properties.userCredentials?.email)
        
        isActive = true
        desk = Desk360(properties: properties)
        
        let registerModel = RegisterModel(appId: properties.appID, deviceId: properties.deviceID, environment: properties.environment, language: properties.language, country: properties.language)
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

    static func fetchTicketList() {
        guard list != nil else { return }
        list?.fetchList()
    }
    
    static func isUrlLocal( _ url: URL) -> Bool {
        return !url.absoluteString.hasPrefix("https://")
    }
}

private extension Desk360 {
    
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
    
    static var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
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
}
