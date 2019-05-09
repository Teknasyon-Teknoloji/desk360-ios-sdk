//
//  Desk360+UI.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

public extension Desk360 {

	@discardableResult
	func push(on viewController: Desk360ViewController, animated: Bool = true) -> UIViewController {
		guard let nav = viewController.navigationController else {
			fatalError("Unable to push Desk360, \(viewController) is not embedded in a navigation controller")
		}
		let vc = listingViewController(in: viewController)
		vc.reuseMode = .push
		nav.pushViewController(vc, animated: animated)
		return vc
	}

	@discardableResult
	func present(in viewController: Desk360ViewController, animated: Bool = true) -> UIViewController {
		let vc = listingViewController(in: viewController)
		vc.reuseMode = .present
		let nav = UINavigationController(rootViewController: vc)
		viewController.present(nav, animated: animated)
		return vc
	}

	private func listingViewController(in viewController: Desk360ViewController) -> ListingViewController {
		let vc = ListingViewController()
		vc.delegate = viewController
		return vc
	}

}
