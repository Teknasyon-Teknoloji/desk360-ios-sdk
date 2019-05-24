//
//  APIError.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import Moya

/// `APIError` defines the set of errors used in the `/Networking` module.
///
/// Conforms to:
///  - `Error`
///  - `LocalizedError`
public enum APIError: Error {

	/// Unauthorized, unable to find cached API token.
	case unauthorized

	/// The request failed.
	case request(Error, response: Response?)

	/// Decoding JSON object failed.
	case decoding(Error, response: Response?)

	/// Server returned an error.
	case server(message: String, response: Response?)

	/// App is under maintenance.
	case underMaintenance(response: Response?)

	/// Unknown server error.
	case unknown(response: Response?)

	/// Error title _`nil` for all but `APIError.underMaintenance`_.
	public var title: String? {
		switch self {
		case .underMaintenance:
			return Desk360.Strings.Maintenance.title
		case .unauthorized:
			return Desk360.Strings.Unauthorized.title

		default:
			return nil
		}
	}

}

extension APIError: LocalizedError {

	/// A localized message describing what error occurred.
	public var errorDescription: String? {
		switch self {
		case .unauthorized:
			return Desk360.Strings.Unauthorized.message
		case .request(let error, _):
			return error.localizedDescription
		case .decoding(let error, _):
			return error.localizedDescription
		case .server(let message, _):
			return message
		case .underMaintenance:
			return Desk360.Strings.Maintenance.message
		case .unknown:
			return Desk360.Strings.Common.unknownError
		}
	}

}

public extension APIError {

	/// Moya Response.
	var response: Response? {
		switch self {
		case .unauthorized:
			return nil
		case .request(_, let response),
			 .decoding(_, let response),
			 .server(_, let response),
			 .underMaintenance(let response),
			 .unknown(let response):
			return response
		}
	}

}
