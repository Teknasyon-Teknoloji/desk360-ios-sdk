//
//  KeyboardNotification.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

/// `KeyboardNotification` offers information about keyboard events.
/// This class is used in both `KeyboardHandling` and `KeyboardObserving`
public final class KeyboardNotification: NSObject {

	/// A `CGRect` that identifies the starting frame rectangle of the keyboard in screen coordinates. The frame rectangle reflects the current orientation of the device.
	public var startFrame: CGRect

	/// A `CGRect` that identifies the ending frame rectangle of the keyboard in screen coordinates. The frame rectangle reflects the current orientation of the device.
	public var endFrame: CGRect

	/// The duration of the animation in seconds.
	public var animationDuration: TimeInterval

	/// A boolean that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is true for the app that caused the keyboard to appear and false for any other apps.
	public var isLocalUser: Bool

	/// A `UIView.AnimationCurve` constant that defines how the keyboard will be animated onto or off the screen.
	public var animationCurve: UIView.AnimationCurve?

	/// Create a new `KeyboardNotification` object from a system `Notification`
	///
	/// - Parameter notification: `Notification`
	init?(notification: Notification) {
		guard let userInfo = notification.userInfo else { return nil }
		guard let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return nil }
		guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
		guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return nil }
		guard let isLocalUser = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool else { return nil }

		self.startFrame = startFrame
		self.endFrame = endFrame
		self.animationDuration = animationDuration
		self.isLocalUser = isLocalUser

		if let curveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
			self.animationCurve = UIView.AnimationCurve(rawValue: curveRawValue)
		}
	}

}
