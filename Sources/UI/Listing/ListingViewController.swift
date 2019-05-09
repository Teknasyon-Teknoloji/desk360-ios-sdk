//
//  ListingViewController.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import UIKit

final class ListingViewController: UIViewController, Layouting {

	typealias ViewType = ListingView
	override func loadView() {
		view = ViewType.create()
	}

	enum ReuseMode {
		case push
		case present
	}
	var reuseMode: ReuseMode = .present

	weak var delegate: Desk360Delegate?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setupNavigationItem()
	}

}

private extension ListingViewController {

	func setupNavigationItem() {
		switch reuseMode {
		case .present:

			navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(didTapDismissBarButtonItem))

		case .push:
			break
		}
	}

	@objc
	func didTapDismissBarButtonItem() {
		dismiss(animated: true)
	}

}
