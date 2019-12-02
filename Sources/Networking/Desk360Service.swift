//
//  Desk360Service.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import Moya

enum Service {
	case register(appKey: String, deviceId: String, appPlatform: String, appVersion: String, timeZone: String, languageCode: String)
	case create(ticket: [MultipartFormData])
	case getConfig(appKey: String)
	case getTickets
	case ticketTypeList
	case ticketWithId(Ticket.ID)
	case ticketMessages(String, Ticket.ID)
}

extension Service: TargetType, AccessTokenAuthorizable {

	var authorizationType: AuthorizationType {
		return .bearer
	}

	var baseURL: URL {
		if Desk360.isDebug {
			return URL(string: "http://52.59.142.138:10380/api/v1")!
		} else {
			return URL(string: "https://teknasyon.desk360.com/api/v1")!
		}
	}

	var validationType: ValidationType {
		return .successCodes
	}

	var path: String {
		switch self {
		case .register:
		 	return "devices/register"
		case .getConfig:
			return "sdk/configurations"
		case .create:
			return "tickets"
		case .getTickets:
			return "tickets"
		case .ticketTypeList:
			return "tickets/types/list"
		case .ticketWithId(let ticketId):
			return "tickets/\(ticketId)"
		case .ticketMessages(_, let ticketId):
			return "tickets/\(ticketId)/messages"
		}
	}

	var method: Moya.Method {
		switch self {
		case .register, .create, .ticketMessages, .getConfig:
			return .post
		case .getTickets, .ticketTypeList, .ticketWithId:
			return .get
		}
	}

	var sampleData: Data {
		return "".data(using: .utf8)!
	}

	var task: Task {
		switch self {
		case .register(let appKey, let deviceId, let appPlatform, let appVersion, let timeZone, let languageCode):
			return .requestParameters(parameters: ["app_key": appKey, "device_id": deviceId, "app_platform": appPlatform, "app_version": appVersion, "time_zone": timeZone, "language_code": languageCode], encoding: JSONEncoding.default)
		case .getConfig(let appKey):
			return .requestParameters(parameters: ["language_code": appKey], encoding: JSONEncoding.default)
		case .create(let ticket):
			return .uploadMultipart(ticket)
		case .ticketTypeList, .ticketWithId, .getTickets:
			return .requestPlain
		case .ticketMessages(let message, let ticketId):
			return Task.requestCompositeParameters(bodyParameters: ["message": message], bodyEncoding: JSONEncoding.default, urlParameters: ["ticket_id": ticketId])
		}
	}

	var headers: [String: String]? {
		return nil
	}

}
