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
	
}
