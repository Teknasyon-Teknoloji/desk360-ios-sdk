//
//  UIButton+Extensions.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import DeviceKit

private var height: CGFloat = {
	let diagonal = Device.current.realDevice.diagonal
	if diagonal >= 6 && diagonal < 7 { return 58.0 }
	if diagonal >= 5 && diagonal < 6 { return 55.0 }
	if diagonal >= 4 && diagonal < 5 { return 45.0 }
	return 50.0
}()

extension UIButton {

	/// Preferred height for autolayout.
	static var preferredHeight: CGFloat {
		return height
	}

	func setImageAndTitle() {
		self.titleLabel?.textAlignment = .center
		self.titleLabel?.adjustsFontSizeToFitWidth = true
		self.titleLabel?.minimumScaleFactor = 0.1
		self.titleLabel?.baselineAdjustment = .alignCenters

//		let offset = (self.frame.size.width - (self.imageView?.frame.size.width ?? 0)) - 30

//		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
//			self.imageEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
//		} else {
//			self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offset)
//		}
		self.imageView?.frame.origin.x = (self.titleLabel?.frame.origin.x ?? 0) - (self.imageView?.frame.width ?? 0) - 15

		self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

	}

//	func setImageAndTitle() {
//		self.titleLabel?.textAlignment = .center
//		self.titleLabel?.adjustsFontSizeToFitWidth = true
//		self.titleLabel?.minimumScaleFactor = 0.3
//		self.titleLabel?.baselineAdjustment = .alignCenters
//
//		let offset = (self.frame.size.width - (self.imageView?.frame.size.width ?? 0)) - 30
//		self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offset)
//		self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//	}

	func setLeftImageAndTitle() {
		self.titleLabel?.textAlignment = .center
		self.titleLabel?.adjustsFontSizeToFitWidth = true
		self.titleLabel?.minimumScaleFactor = 0.1
		self.titleLabel?.baselineAdjustment = .alignCenters

		let offset = (self.frame.size.width - (self.imageView?.frame.size.width ?? 0)) + 10

		if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
			self.imageEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
		} else {
			self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offset)
		}

		self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)

	}

}
