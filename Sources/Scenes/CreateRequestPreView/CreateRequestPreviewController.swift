//
//  CreateRequestPreviewController.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

/// `CreateRequestPreviewController`
final class CreateRequestPreviewController: UIViewController, Layouting, UIGestureRecognizerDelegate {

	/// Layoutable view type
	typealias ViewType = CreatRequestPreView
	
	/// Creates the view that the controller manages.
	override func loadView() {
		view = ViewType.create()
	}
	
	/// Called after the controller's view is loaded into memory.
	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.createRequestButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)

	}
	
	/// Notifies the view controller that its view is about to be added to a view hierarchy.
	///
	/// - Parameter animated: If true, the view is being added to the window using an animation.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configure()
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))
	}
	
	/// Called to notify the view controller that its view has just laid out its subviews.
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.layoutableView.bottomScrollView.contentSize = CGSize(width: self.layoutableView.bottomScrollView.frame.size.width, height: self.layoutableView.bottomDescriptionLabel.frame.size.height + self.layoutableView.preferredSpacing * 0.5)
		}

	}
	
	/// Back button popView action.
	@objc func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}

}

//MARK: - Actions
extension CreateRequestPreviewController {
	
	/// Create Request Button open CreateRequestViewController action.
	@objc func didTapSendRequestButton() {
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: true), animated: true)
	}

}

//MARK: - Configure
extension CreateRequestPreviewController {
	
	/// Configures for create request preview and CreateRequestPreviewController navigation title
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
