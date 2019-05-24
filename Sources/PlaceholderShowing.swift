//
//  PlaceholderShowing.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import SnapKit

/// Conform to `PlaceholderShowing` protocol in a `UIViewController` to show a custom placeholder view controller.
public protocol PlaceholderShowing: AnyObject {

	/// Placeholder view controller type.
	///
	/// Any `UIViewController` that conforms to the `PlaceholderType` protocol.
	///
	associatedtype Placeholder: PlaceholderType & UIViewController

	/// Placeholder view controller.
	var placeholderViewController: Placeholder { get set }

	/// Show placeholder view controller.
	func showPlaceholderViewController()

	/// Hide placeholder view controller.
	func hidePlaceholderViewController()

}

// MARK: - Default implementation for UIViewController.
public extension PlaceholderShowing where Self: UIViewController {

	/// Show placeholder view controller.
	func showPlaceholderViewController() {
		if children.contains(where: { $0 is Placeholder }) { return }
		add(placeholderViewController)
	}

	/// Hide placeholder view controller.
	func hidePlaceholderViewController() {
		placeholderViewController.remove()
	}

}

// MARK: - Private `UIViewController` helpers
private extension UIViewController {

	/// Add child view controller.
	///
	/// - Parameter child: child `UIViewController`
	func add(_ child: UIViewController) {
		addChild(child)
		view.addSubview(child.view)
		child.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		child.didMove(toParent: self)
	}

	/// Remove `self` from its parent view controller.
	func remove() {
		guard parent != nil else { return }

		willMove(toParent: nil)
		removeFromParent()
		view.snp.removeConstraints()
		view.removeFromSuperview()
	}

}
