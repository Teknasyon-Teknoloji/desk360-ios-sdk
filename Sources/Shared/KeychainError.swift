//
//  KeychainError.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

/// `KeychainError` defines the set of errors used in `SingleKeychainStore`.
enum KeychainError: Error {

	/// Unable to save obejct to Keychain
	case saveFailure

}

extension KeychainError: LocalizedError {

	/// Error description
	var errorDescription: String? {
		return localizedDescription
	}

	/// Error localized description
	var localizedDescription: String {
		return "Unable to save obejct to Keychain"
	}

}
