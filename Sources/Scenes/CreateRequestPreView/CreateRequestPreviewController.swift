//
//  CreateRequestPreviewController.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

final class CreateRequestPreviewController: UIViewController, Layouting, UIGestureRecognizerDelegate {

	typealias ViewType = CreatRequestPreView
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

		layoutableView.createRequestButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)

		guard let check = checkLastClass, check else { return }
		// let count = navigationController?.viewControllers.count ?? 0
		// navigationController?.viewControllers.removeSubrange(count-2..<count-1)

//		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configure()
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.layoutableView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.bottomScrollView.frame.size.width, height: self.layoutableView.bottomDescriptionLabel.frame.size.height + self.layoutableView.preferredSpacing * 0.5)
//			self.layoutableView.createRequestButton.setImageAndTitle()
		}

	}

	@objc
	func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}

}

extension CreateRequestPreviewController {

	@objc func didTapSendRequestButton() {
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: true), animated: true)
	}

}

extension CreateRequestPreviewController {

	func configure() {

		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model?.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
		let navigationTitle = NSAttributedString(string: Config.shared.model?.createPreScreen?.navigationTitle ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
		let titleLabel = UILabel()
		titleLabel.attributedText = navigationTitle
		titleLabel.sizeToFit()
		titleLabel.textAlignment = .center
		titleLabel.textColor = Colors.navigationTextColor
		navigationItem.titleView = titleLabel

		navigationItem.title = Config.shared.model?.createPreScreen?.navigationTitle
		self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor )
		navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		layoutableView.configure()
	}

}
