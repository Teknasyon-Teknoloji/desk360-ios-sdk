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
public typealias TicketsHandler = ((Result<[Ticket], Error>) -> Void)

@objc public enum Desk360Error: Int, LocalizedError {
    case notInitalized

    public var errorDescription: String? {
        switch self {
        case .notInitalized: return "The Desk360 SDK is not intialized properly. Please call start(with:) first"

        }
    }
}

@objc public enum Desk360Environment: Int {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
    case test

    case sandbox
    case production

    var stringValue: String {
        switch self {
            case .test:
                return "test"
            case .sandbox:
                return "sandbox"
            case .production:
                return "production"
        }
    }
}

@objc open class Desk360: NSObject {

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

    static let authPlugin = AccessTokenPlugin { _ in Desk360.token ?? "" }

    static let apiProvider = MoyaProvider<Service>(plugins: [authPlugin])

    static var isRegister = false

    static var applaunchChecker = false

    static var didTapNotification = false

    /// Whether internet is reachable or not.
    static var isReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    /// Creates DESK360 instance configured with the given properties.
    /// - Parameter properties: DESK360 configuration properties.
	@objc public init(properties: Desk360Properties) {
		super.init()
        listenForAppLifeCycleEvents()
        Desk360.properties = properties
		Desk360.appVersion = Desk360.getAppVersion()
		Desk360.sdkVersion = Desk360.getSdkVersion()
        Fonts.Montserrat.registerFonts()
    }

	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:) before using the SDK")
		}
		return aDesk
	}

	@objc public static func setPushToken(deviceToken: Data? = nil) {
		guard let token = deviceToken else { return }
		let tokenString = token.reduce("", {$0 + String(format: "%02X", $1)})
		self.pushToken = tokenString
		print("pushToken: \(String(describing: pushToken))")
	}

	@objc public static func applicationLaunchChecker(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] else { return }
        guard let data = remoteNotif["data"] as? [String: AnyObject] else { return }
        guard let id = userInfoHandle(data) else { return }
        Desk360.didTapNotification = true
        Desk360.applaunchChecker = true
        Desk360.messageId = id
    }

    @objc public static func willNotificationPresent(_ userInfo: [AnyHashable: Any]?) {

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

	@objc public static func applicationUserInfoChecker(_ userInfo: [AnyHashable: Any]?) {

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
                    Desk360.messageId = nil
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

	@objc public static func showWithPushDeeplink(on viewController: UIViewController?, animated: Bool = false) {

		guard Desk360.messageId != nil, let viewController = viewController else { return }
		guard let registerModel = Stores.registerModel.object else { return }
		var desk360Env: Desk360Environment = .production
		if registerModel.environment == Desk360Environment.sandbox.stringValue {
			desk360Env = .sandbox
		}

        let properties = Desk360Properties(
            appID: registerModel.appId,
            deviceID: registerModel.deviceId,
			environment: desk360Env,
            language: registerModel.language,
            country: registerModel.country
        )

        desk = Desk360(properties: properties)

		let listingViewController = ListingViewController()
		listingViewController.hidesBottomBarWhenPushed = true
		let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
		desk360Navcontroller.modalPresentationStyle = .fullScreen
        viewController.present(desk360Navcontroller, animated: true, completion: nil)

	}

    @objc public static func start(using properties: Desk360Properties, requireRegister: Bool = false) {
        try? Stores.userName.save(properties.userCredentials?.name)
        try? Stores.userMail.save(properties.userCredentials?.email)

        isActive = true
        desk = Desk360(properties: properties)

        let registerModel = RegisterModel(appId: properties.appKey, deviceId: properties.deviceID, environment: properties.environment, language: properties.language, country: properties.language)
        try? Stores.registerModel.save(registerModel)

        Stores.setStoresInitialValues()
        print("Desk360 SDK was initialized successfully!")
        
        if requireRegister {
            Desk360Networking.register(completion: { _ in })
        }
    }

	@objc public static func show(on viewController: UIViewController, animated: Bool = true, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        let listingViewController = ListingViewController()
        listingViewController.hidesBottomBarWhenPushed = true
        let desk360Navcontroller = UINavigationController(rootViewController: listingViewController)
        desk360Navcontroller.modalPresentationStyle = presentationStyle
        viewController.present(desk360Navcontroller, animated: true, completion: nil)
    }

    /// Fetchs the unread ticket
    /// - Parameter completion: The ticket fetching result/
    public static func getUnreadTickets(completion: @escaping TicketsHandler) {
        Desk360Networking.getUnreadMessages(completion: completion)
    }

    /// Instantiate an instance of Ticket details view controller with the given ticket and return it,
    /// - Parameter ticket: The  ticket to be shown
    /// - Returns: Ticket details view controller
    public static func ticketDetailsViewController(ofTicket ticket: Ticket) -> UIViewController {
        return ConversationViewController(request: ticket)
    }

    /// Prsensts the Ticket details view controller of the given ticket.
    /// - Parameters:
    ///   - ticket: The ticket to be shown
    ///   - viewController: A viewcontroller to present ticket details on it.
    ///   - animated: Presentation animation `Default` true
    public static func showDetails(ofTicket ticket: Ticket, on viewController: UIViewController, animated: Bool = true) {
        let ticketViewController = ConversationViewController(request: ticket)
        viewController.present(ticketViewController, animated: animated)
    }

    /// Checks whether the incoming notification is dedicated to Desk360 or not.
    /// - Parameter notification: The incoming notification.
    /// - Returns: returns `true` if it can handle it or `false` otherwise.
    public static func canHandleNotfication(_ notification: [AnyHashable: Any]) -> Bool {
        guard let data = notification["data"] as? [String: AnyObject] else { return false }
        return userInfoHandle(data) != nil
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

    func listenForAppLifeCycleEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotificationStatus), name: UIApplication.willTerminateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotificationStatus), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func changeNotificationStatus() {
        if #available(iOS 11.0, *) {
            PDFDocumentCache.clear()
        }
    }
    
    static func getAppVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "0.0.0"
        }
        return version
    }

    static func getSdkVersion() -> String {
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
    
    @objc public static func updateChatLocalization(coinCountText: String, characterCountText: String, writeSomethingCountText: String) {
        Desk360.properties?.coinCountText = coinCountText
        Desk360.properties?.characterCountText = characterCountText
        Desk360.properties?.writeSomethingCountText = writeSomethingCountText
    }
}

private final class Desk360Networking {

    static func register(completion: @escaping((Result<Void, Error>) -> Void)) {
        guard let props = Desk360.properties else {
            completion(.failure(Desk360Error.notInitalized))
            return
        }

        Desk360.apiProvider.request(.register(appKey: props.appKey, deviceId: props.deviceID, appPlatform: props.appPlatform, appVersion: Desk360.appVersion, timeZone: props.timeZone, languageCode: props.language)) {  result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let register = try? response.map(DataResponse<RegisterRequest>.self) else { return }
                Desk360.isRegister = true
                Desk360.token = register.data?.accessToken
                try? Stores.tokenStore.save(register.data?.accessToken ?? "")
                try? Stores.registerExpiredAt.save(register.data?.expiredDate)
                completion(.success(()))
            }
        }
    }

    static func getUnreadMessages(completion: @escaping TicketsHandler) {
        register { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                fetchRequests { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let tickets):
                        let unreadTickets = tickets.filter({ $0.status == .unread })
                        completion(.success(unreadTickets))
                    }
                }
            }
        }
    }

    private static func fetchRequests(completion: @escaping TicketsHandler) {

        Desk360.apiProvider.request(.getTickets) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let tickets = try? response.map(DataResponse<[Ticket]>.self) else { return }
                guard let data = tickets.data else { return }
                try? Stores.ticketsStore.save(data)
                completion(.success(data))
            }
        }
    }
}

extension Desk360 {
    /// returns Conversation(Chat) View Controller for using to another app
    /// - Parameters:
    ///   - ticket: will use for ticketWithId API
    ///   - characterPerCoin: character value of 1 coin
    ///   - totalCoin: user's total coin balance
    /// - Returns: Conversation(Chat) View Controller
    public static func getConversationViewController(ticket: Ticket?,
                                                     characterPerCoin: Int,
                                                     totalCoin: Int,
                                                     name: String,
                                                     email: String) -> ConversationViewController {
        guard let ticket = ticket else { return .init() }
        let viewController = ConversationViewController(request: ticket,
                                                        characterPerCoin: characterPerCoin,
                                                        totalCoin: totalCoin,
                                                        name: name,
                                                        email: email)
        return viewController
    }
    
    /// set SDK's language from App
    /// - Parameter code: language code
    public static func setLanguage(code: String) {
        guard var registerModel = Stores.registerModel.object else { return }
        registerModel.language = code
        try? Stores.registerModel.save(registerModel)
    }
}
