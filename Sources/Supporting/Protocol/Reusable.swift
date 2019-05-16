//
//  Reusable.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import UIKit

/// Conform to `Reusable` protocol in reusable objects like `UITableViewCell`.
protocol Reusable {

	/// Unique reuse identifier.
	static var reuseIdentifier: String { get }

}

// MARK: - Default implementation for UITableViewCell.
extension Reusable where Self: UITableViewCell {

	/// UITableViewCell unique reuse identifier.
	static var reuseIdentifier: String {
		return String(describing: type(of: self))
	}

}
