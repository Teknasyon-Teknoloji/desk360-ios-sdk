//
//  PlaceholderType.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import UIKit

/// Conform to `PlaceholderType` in `UIViewController`s you want to use as placeholdrs.
public protocol PlaceholderType: AnyObject {

	/// Optional title `UILabel`
	var titleLabel: UILabel? { get }

	/// Optional description `UIlabel`
	var descriptionLabel: UILabel? { get }

	/// Optional `UIImageView`
	var imageView: UIImageView? { get }

	/// Optional action `UIButton`
	var actionButton: UIButton? { get }

}
