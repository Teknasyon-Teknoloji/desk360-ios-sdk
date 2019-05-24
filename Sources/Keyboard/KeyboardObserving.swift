//
//  KeyboardObserving.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import Foundation

/// Conform to `KeyboardObserving` protocol in view controllers to observe keyboard events and pass them to a `KeyboardHandling` view.
public protocol KeyboardObserving: AnyObject {

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

	/// Start observing keyboard events sent from the OS.
	func registerForKeyboardEvents()

}

// MARK: - Default implementation for UIViewController.
public extension KeyboardObserving where Self: UIViewController {

	func registerForKeyboardEvents() {
		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillShow(KeyboardNotification(notification: notification))
		}

		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardDidShow(KeyboardNotification(notification: notification))
		}

		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillHide(KeyboardNotification(notification: notification))
		}

		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardDidHide(KeyboardNotification(notification: notification))
		}

		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillChangeFrame(KeyboardNotification(notification: notification))
		}

		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardDidChangeFrame(KeyboardNotification(notification: notification))
		}
	}

}
