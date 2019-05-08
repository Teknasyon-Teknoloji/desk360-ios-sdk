//
//  DeskMessageCreateRequest.swift
//  Desk360
//
//  Created by Omar on 5/8/19.
//

import Foundation

public enum DeskMessageCreateRequest {

	case text(String)

}

extension DeskMessageCreateRequest: Encodable {

	private enum CodingKeys: String, CodingKey {
		case message
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		switch self {
		case .text(let message):
			try container.encode(message, forKey: .message)
		}
	}

}
