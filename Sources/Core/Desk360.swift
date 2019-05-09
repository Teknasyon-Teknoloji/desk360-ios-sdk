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

	func createTicket(request: DeskTicketCreateRequest, _ completionHandler: @escaping  CreateResult) {}

	func addMessage(request: DeskMessageCreateRequest, toTicketWithId id: Int, _ completionHandler: @escaping  CreateResult) {}

	func fetchTickets(_ completionHandler: @escaping  TicketsResult) {}

	func fetchTicket(withId id: Int, _ completionHandler: @escaping  TicketResult) {}

}
