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
		Desk360.Config.backgroundColor = UIColor(displayP3Red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
		Desk360.Config.textColor = .white

		Desk360.Config.Requests.Listing.NavItem.icon = #imageLiteral(resourceName: "iconNavigationbarAdd")
		Desk360.Config.Requests.Listing.tintColor = UIColor(displayP3Red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
		Desk360.Config.Requests.Listing.Placeholder.image = #imageLiteral(resourceName: "iconSupportCreate")

		Desk360.Config.Requests.Listing.Placeholder.CreateButton.backgroundColor = UIColor(displayP3Red: 88/255, green: 176/255, blue: 250/255, alpha: 1)
		Desk360.Config.Requests.Listing.Placeholder.CreateButton.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		Desk360.Config.Requests.Listing.Placeholder.Title.font = UIFont.systemFont(ofSize: 18, weight: .regular)

		Desk360.Config.Requests.Listing.Cell.backgroundColor = .white
		Desk360.Config.Requests.Listing.Cell.Expired.icon = #imageLiteral(resourceName: "iconButtonContactUsExpired")
		Desk360.Config.Requests.Listing.Cell.Open.icon = #imageLiteral(resourceName: "iconButtonContactUsExpired")
		Desk360.Config.Requests.Listing.Cell.Unread.icon = #imageLiteral(resourceName: "iconButtonContactUsUnread")
		Desk360.Config.Requests.Listing.Cell.Read.icon = #imageLiteral(resourceName: "iconButtonContactUsRead")
		Desk360.Config.Requests.Listing.Cell.tintColor = .black
		Desk360.Config.Requests.Listing.Cell.Expired.titleTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Unread.titleTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Read.titleTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Open.titleTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Expired.dateTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Unread.dateTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Read.dateTextColor = .black
		Desk360.Config.Requests.Listing.Cell.Open.dateTextColor = .black

		Desk360.Config.Requests.Create.borderWidth = 1

		Desk360.Config.Conversation.MessageCell.Receiver.backgroundColor = .white
		Desk360.Config.Conversation.MessageCell.Sender.backgroundColor =  UIColor(displayP3Red: 67/255, green: 96/255, blue: 145/255, alpha: 1)

		Desk360.Config.Conversation.Input.height = 75
		Desk360.Config.Conversation.Input.TextView.tintColor = .black
		Desk360.Config.Conversation.Input.SendButton.tintColor = UIColor(displayP3Red: 67/255, green: 96/255, blue: 145/255, alpha: 1)
		Desk360.Config.Conversation.Input.TextView.Placeholder.textColor = UIColor(displayP3Red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
		Desk360.Config.Conversation.Input.TextView.backgroundColor = .clear
		Desk360.Config.Conversation.Input.TextView.borderColor = UIColor(displayP3Red: 191/255, green: 191/255, blue: 193/255, alpha: 1)
		Desk360.Config.Conversation.Input.SendButton.icon = #imageLiteral(resourceName: "iconButtonContactUsSendMessage")
		Desk360.Config.Conversation.Input.backgroundColor = UIColor(displayP3Red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
		Desk360.Config.Conversation.Input.CreateRequestButton.tintColor = .white
		Desk360.Config.Conversation.Input.TextView.textColor = .black

		Desk360.Config.Conversation.MessageCell.Receiver.dateTextColor = UIColor(displayP3Red: 82/255, green: 90/255, blue: 126/255, alpha: 1)
		Desk360.Config.Conversation.MessageCell.Receiver.messageTextColor = UIColor(displayP3Red: 82/255, green: 90/255, blue: 126/255, alpha: 1)

		Desk360.Config.Conversation.MessageCell.Sender.dateTextColor = .white
		Desk360.Config.Conversation.MessageCell.Sender.messageTextColor = .white

		Desk360.Config.Requests.Listing.Placeholder.CreateButton.borderColor = .clear
		Desk360.Config.Requests.Listing.Placeholder.CreateButton.borderWidth = 0
		Desk360.Config.Requests.Listing.Placeholder.CreateButton.cornerRadius = 20
		Desk360.Config.Requests.Listing.borderWidth = 1

		Desk360.Config.Requests.Create.DropDownListView.arrowColor = UIColor(displayP3Red: 88/255, green: 176/255, blue: 250/255, alpha: 1)
		Desk360.Config.Requests.Create.DropDownListView.textColor = UIColor(displayP3Red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
		Desk360.Config.Requests.Create.DropDownListView.arrowSize = 20
		Desk360.Config.Requests.Create.DropDownListView.borderWidth = 1
		Desk360.Config.Requests.Create.DropDownListView.rowBackgroundColor = .white
		Desk360.Config.Requests.Create.DropDownListView.selectedRowColor = .white

		Desk360.Config.Requests.Listing.Placeholder.Title.textColor = UIColor(displayP3Red: 134/255, green: 134/255, blue: 134/255, alpha: 1)
		Desk360.Config.Requests.Listing.Placeholder.backgroundColor = UIColor(displayP3Red: 243/255, green: 243/255, blue: 243/255, alpha: 1)

		Desk360.Config.Requests.Create.backgroundColor = UIColor(displayP3Red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
		Desk360.Config.Requests.Create.textColor = .black
		Desk360.Config.Requests.Create.PlaceholderTextColor = UIColor(displayP3Red: 166/255, green: 166/255, blue: 168/255, alpha: 1)
		Desk360.Config.Requests.Create.NameTextField.backgroundColor = .clear
		Desk360.Config.Requests.Create.EmailTextField.backgroundColor = .clear
		Desk360.Config.Requests.Create.MessageTextView.backgroundColor = .clear
		Desk360.Config.Requests.Create.SubjectTextField.backgroundColor = .clear
		Desk360.Config.Requests.Create.borderColor = UIColor.black.withAlphaComponent(0.5)
		Desk360.Config.Requests.Create.DropDownListView.borderColor = UIColor.black.withAlphaComponent(0.5)
		Desk360.Config.Requests.Create.DropDownListView.placeholderTextColor = UIColor(displayP3Red: 166/255, green: 166/255, blue: 168/255, alpha: 1)
		Desk360.Config.Requests.Create.tintColor = .black
		Desk360.Config.Requests.Create.SendButton.backgroundColor = UIColor(displayP3Red: 88/255, green: 176/255, blue: 250/255, alpha: 1)
		Desk360.Config.Requests.Create.SendButton.tintColor = .white
		Desk360.Config.Requests.Create.SendButton.cornerRadius = 20

		Desk360.Config.Requests.Listing.Cell.lineColor = UIColor(displayP3Red: 213/255, green: 213/255, blue: 213/255, alpha: 1).withAlphaComponent(0.6)
	}
}
