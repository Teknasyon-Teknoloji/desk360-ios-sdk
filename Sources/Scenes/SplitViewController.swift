//
//  SplitViewController.swift
//  Alamofire
//
//  Created by samet on 29.05.2019.
//

import UIKit

final class SplitViewController: UISplitViewController {

	var masterViewController: ListingViewController!
	var detailViewController: ConversationViewController!
	static var chekPrimary: Bool = true

	convenience init(masterViewController: ListingViewController, detailViewController: ConversationViewController) {
		self.init()
		self.masterViewController = masterViewController
		self.detailViewController = detailViewController

		setupViewControllers()

		delegate = self

	}

	private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented, use init(masterController:, detailController:) instead")
	}

	func setupViewControllers() {
		masterViewController.delegate = self

		viewControllers = [
			UINavigationController(rootViewController: masterViewController),
			UIViewController()
		]
		preferredDisplayMode = .allVisible

	}

}

// MARK: - UISplitViewControllerDelegate
extension SplitViewController: UISplitViewControllerDelegate {

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return SplitViewController.chekPrimary
	}

//	func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
//		return false
//	}
//
//	func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
//		return true
//	}

//	override func show(_ vc: UIViewController, sender: Any?) {
//
//	}

}

// MARK: - ListingViewControllerDelegate
extension SplitViewController: ListingViewControllerDelegate {

	func listingViewController(_ viewController: ListingViewController, didSelectTicket ticket: Ticket) {
	}

}
