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
	private(set) public var appSecret: String!

	private let baseUrl = URL(string: "https://google.com/")!
	private let session = URLSession.shared

	public typealias CreateResult = (_ result: Result<Bool, DeskError>) -> Void
	public typealias TicketsResult = (_ result: Result<[DeskTicket], DeskError>) -> Void
	public typealias TicketResult = (_ result: Result<DeskTicket, DeskError>) -> Void

	public init(appId: String, appSecret: String) {
		self.appId = appId
		self.appSecret = appSecret
	}

	public static var shared: Desk360 {
		guard let aDesk = desk else {
			fatalError("Desk360 is not yet initialized, make sure to call Desk360.start(appId:, appSecret:) before using the SDK")
		}
		return aDesk
	}

	public static func start(appId: String, appSecret: String) {
		desk = Desk360(appId: appId, appSecret: appSecret)
		print("Desk360 SDK was initialized successfully!")
	}

}

// MARK: - Networking
public extension Desk360 {

	func createTicket(request: DeskTicketCreateRequest, _ completionHandler: @escaping  CreateResult) {
		let data = encode(object: request)
		let request = createRequest(path: "tickets", body: data, method: "POST")
		session.dataTask(with: request) { (data, response, error) in

		}
	}

	func addMessage(request: DeskMessageCreateRequest, toTicketWithId id: Int, _ completionHandler: @escaping  CreateResult) {
		let data = encode(object: request)
		let request = createRequest(path: "tickets/\(id)/messages", body: data, method: "POST")
		session.dataTask(with: request) { (data, response, error) in

		}
	}

	func fetchTickets(_ completionHandler: @escaping  TicketsResult) {
		let request = createRequest(path: "tickets", body: nil, method: "GET")
		session.dataTask(with: request) { (data, response, error) in

		}
	}

	func fetchTicket(withId id: Int, _ completionHandler: @escaping  TicketResult) {
		let request = createRequest(path: "tickets/\(id)", body: nil, method: "GET")
		session.dataTask(with: request) { (data, response, error) in

		}
	}

}

private extension Desk360 {

	func createRequest(path: String, body: Data?, method: String) -> URLRequest {
		let url = baseUrl.appendingPathComponent(path)
		var request = URLRequest(url: url)
		request.httpMethod = method
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = body
		return request
	}

	func encode<T: Encodable>(object: T) -> Data {
		let data = try! JSONEncoder().encode(object)
		return injectingMeta(into: data)
	}

	func injectingMeta(into data: Data) -> Data {
		var dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
		dict["app_id"] = appId
		dict["app_secret"] = appSecret
		dict["source"] = "Mobile"
		dict["platform"] = "iOS"
		dict["device_id"] = UIDevice.current.uniqueIdentifier
		dict["country_code"] = Locale.current.countryCode
		return try! JSONSerialization.data(withJSONObject: dict, options: [])
	}

}
