//
//  Reusable.swift
//  Example
//
//  Created by samet on 16.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

/// Conform to `Reusable` protocol in reusable objects like `UITableViewCell` or `UICollectionViewCell`
public protocol Reusable {

	/// Unique reuse identifier.
	static var reuseIdentifier: String { get }

}

// MARK: - Default implementation for UITableViewCell.
public extension Reusable where Self: UITableViewCell {

	/// UITableViewCell unique reuse identifier.
	static var reuseIdentifier: String {
		return String(describing: type(of: self))
	}

}

// MARK: - Default implementation for UICollectionViewCell.
public extension Reusable where Self: UICollectionViewCell {

	/// UICollectionViewCell unique reuse identifier.
	static var reuseIdentifier: String {
		return String(describing: type(of: self))
	}

}

// MARK: - Default implementation for UITableViewHeaderFooterView.
public extension Reusable where Self: UITableViewHeaderFooterView {

	/// UITableViewHeaderFooterView unique reuse identifier.
	static var reuseIdentifier: String {
		return String(describing: type(of: self))
	}

}

// MARK: - Default implementation for UICollectionReusableView.
public extension Reusable where Self: UICollectionReusableView {

	/// UICollectionReusableView unique reuse identifier.
	static var reuseIdentifier: String {
		return String(describing: type(of: self))
	}

}

