//
//  SuccsessViewController.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

final class SuccsessViewController: UIViewController, Layouting, UIGestureRecognizerDelegate {

	typealias ViewType = SuccessView
	
	/// Creates the view that the controller manages.
	override func loadView() {
		view = ViewType.create()
	}

	var checkLastClass: Bool?

	/// Initializes a document of a specified type.
	/// - Parameter tickets: tickets for listing
	convenience init(checkLastClass: Bool) {
		self.init()
		self.checkLastClass = checkLastClass
	}

	/// Called after the controller's view is loaded into memory.
	override func viewDidLoad() {
		super.viewDidLoad()
        Desk360.thanksVC = self
		layoutableView.showListButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)
	}
	
	/// Notifies the view controller that its view is about to be removed from a view hierarchy.
	/// - Parameter animated: If true, the disappearance of the view is being animated.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Desk360.thanksVC = nil
    }
	
	/// Notifies the view controller that its view is about to be added to a view hierarchy.
	/// - Parameter animated: If true, the view is being added to the window using an animation.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configure()

		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.close(target: self, action: #selector(didTapBackButton))
	}

	/// Called to notify the view controller that its view has just laid out its subviews.
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.layoutableView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.bottomScrollView.frame.size.width, height: self.layoutableView.bottomDescriptionLabel.frame.size.height + self.layoutableView.preferredSpacing * 0.5)
		}
	}
	
	/// Notifies the container that its trait collection changed. Required.
	/// - Parameters:
	///   - newCollection: The traits to be applied to the container.
	///   - coordinator: The transition coordinator object managing the trait change. You can use this object to animate any changes or to get information about the transition that is in progress.
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
			if UIApplication.shared.statusBarOrientation.isLandscape {
				self.layoutableView.imageView.isHidden = true
			} else {
				self.layoutableView.imageView.isHidden = false
			}
		})
	}
	
	/// Back button action
	@objc func didTapBackButton() {
        Desk360.thanksVC = nil
		self.dismiss(animated: true, completion: nil)
	}

}

// MARK: - Actions
extension SuccsessViewController {

	/// Button action for fetching ticket list
	@objc func didTapSendRequestButton() {
        Desk360.thanksVC = nil
        self.navigationController?.popToRootViewController(animated: true)
        Desk360.fetchTicketList()
	}

}

// MARK: - Configure
extension SuccsessViewController {

	/// Configuration for success view controller
	func configure() {
		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
		let navigationTitle = NSAttributedString(string: Config.shared.model?.successScreen?.navigationTitle ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
		let titleLabel = UILabel()
		titleLabel.attributedText = navigationTitle
		titleLabel.sizeToFit()
		titleLabel.textAlignment = .center
		titleLabel.textColor = Colors.navigationTextColor
		navigationItem.titleView = titleLabel

		navigationItem.title = Config.shared.model?.successScreen?.navigationTitle
		self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor)
		navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		layoutableView.configure()
	}

}
