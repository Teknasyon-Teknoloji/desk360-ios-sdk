//
//  ViewController.swift
//  Example
//
//  Created by Omar on 5/9/19.
//  Copyright © 2019 Teknasyon. All rights reserved.
//

import UIKit
import Desk360

final class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		configureDesk360()
	}

	@IBAction func didTapPresentButton(_ sender: UIButton) {
		Desk360.present(in: self)
	}

	@IBAction func didTapPushButton(_ sender: UIButton) {
		Desk360.push(on: self)
	}

}

extension ViewController {

	func configureDesk360() {
		
		Desk360.Config.theme = .light
		Desk360.Config.Requests.Listing.NavItem.icon = #imageLiteral(resourceName: "iconNavigationbarAdd")
		Desk360.Config.Requests.Listing.Placeholder.image = #imageLiteral(resourceName: "iconSupportCreate")

		Desk360.Config.Requests.Listing.Cell.Expired.icon = #imageLiteral(resourceName: "iconButtonContactUsExpired")
		Desk360.Config.Requests.Listing.Cell.Open.icon = #imageLiteral(resourceName: "iconButtonContactUsExpired")
		Desk360.Config.Requests.Listing.Cell.Unread.icon = #imageLiteral(resourceName: "iconButtonContactUsUnread")
		Desk360.Config.Requests.Listing.Cell.Read.icon = #imageLiteral(resourceName: "iconButtonContactUsRead")
		Desk360.Config.Conversation.Input.SendButton.icon = #imageLiteral(resourceName: "iconButtonContactUsSendMessage")
		Desk360.Config.Requests.Create.DropDownListView.arrowIcon = #imageLiteral(resourceName: "arrow")

	}
}
