//
//  SuccsessViewController.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

final class SuccsessViewController: UIViewController, Layouting, UIGestureRecognizerDelegate {

	typealias ViewType = SuccessView
	override func loadView() {
		view = ViewType.create()
	}

	var checkLastClass: Bool?

	convenience init(checkLastClass: Bool) {
		self.init()
		self.checkLastClass = checkLastClass
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.showListButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)

		guard let check = checkLastClass, check else { return }
		//let count = navigationController?.viewControllers.count ?? 0
		//navigationController?.viewControllers.removeSubrange(0..<count-1)

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configure()

		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.close(target: self, action: #selector(didTapBackButton))
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.layoutableView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.bottomScrollView.frame.size.width, height: self.layoutableView.bottomDescriptionLabel.frame.size.height + self.layoutableView.preferredSpacing * 0.5)
//			self.layoutableView.showListButton.setImageAndTitle()
		}
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
			if UIApplication.shared.statusBarOrientation.isLandscape {
				self.layoutableView.imageView.isHidden = true
			} else {
				self.layoutableView.imageView.isHidden = false
			}
		})
	}

	@objc
	func didTapBackButton() {
		self.dismiss(animated: true, completion: nil)
	}

}

extension SuccsessViewController {

	@objc func didTapSendRequestButton() {
		//navigationController?.pushViewController(ListingViewController(), animated: true)
        navigationController?.popToRootViewController(animated: true)
        Desk360.fetchTicketList()
	}

}

extension SuccsessViewController {

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
