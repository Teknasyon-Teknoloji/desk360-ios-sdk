//
//  DeskTicket.swift
//  Desk360
//
//  Created by Omar on 5/7/19.
//

import Foundation

public struct DeskTicket: Codable {

	public enum Status: String, Codable {
		case open
		case expired
		case read
		case unread
	}

	public struct Message: Codable {

		public var id: Int
		public var message: String
		public var created: Date
		public var isAnswer: Bool

	}

	public var id: Int
	public var status: Status
	public var name: String
	public var email: String
	public var subject: String
	public var created: Date

	public var messages: [Message]?

}

extension DeskTicket: Equatable {

	public static func == (lhs: DeskTicket, rhs: DeskTicket) -> Bool {
		return lhs.id == rhs.id
	}

}

extension DeskTicket: Comparable {

	public static func < (lhs: DeskTicket, rhs: DeskTicket) -> Bool {
		return lhs.created > rhs.created
	}

}
