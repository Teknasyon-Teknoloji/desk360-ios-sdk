//
//  KeyboardHandling.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import Foundation

/// Conform to `KeyboardHandling` protocol in views to handle keyboard events sent from its parent view controller.
public protocol KeyboardHandling: AnyObject {

	/// Called right before the keyboard is presented.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardWillShow(_ notification: KeyboardNotification?)

	/// Called right after the keyboard is presented.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardDidShow(_ notification: KeyboardNotification?)

	/// Called right before the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardWillHide(_ notification: KeyboardNotification?)

	/// Called right after the keyboard is hidden.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardDidHide(_ notification: KeyboardNotification?)

	/// Called right before the keyboard is about to change its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardWillChangeFrame(_ notification: KeyboardNotification?)

	/// Called right after the keyboard did changed its frame.
	///
	/// - Parameter notification: `KeyboardNotification`
	func keyboardDidChangeFrame(_ notification: KeyboardNotification?)

}
