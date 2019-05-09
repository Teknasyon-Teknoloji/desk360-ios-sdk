//
//  DeskConfig.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

public extension Desk360 {

	struct Config {
		private init() {}

		public static var backgroundColor: UIColor? {
			get {
				return UIColor(hex: Stores.backgroundColor?.object)
			}
			set {
				try? Stores.backgroundColor?.save(newValue?.hexString())
			}
		}

		public static var textColor: UIColor? {
			get {
				return UIColor(hex: Stores.textColor?.object)
			}
			set {
				try? Stores.textColor?.save(newValue?.hexString())
			}
		}

	}

}
