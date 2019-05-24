//
//  Desk360+Config.swift
//  Desk360
//
//  Created by Omar on 5/16/19.
//

import Foundation

// swiftlint:disable file_length

/// Use `Desk360.Config` to set up the contact us page in your application.
public extension Desk360 {

	struct Config {
		private init() {}

		/// The background color for view controller. _default is white_
		public static var backgroundColor: UIColor = .white

		/// The text color for view controller. _default is black_
		public static var textColor: UIColor = .black

		/// The tint color for view controller. _default is black_
		public static var tintColor: UIColor = .black

		/// The corner radius for buttons. _default is 8_
		public static var cornerRadius: CGFloat = 8

		/// The font for labels and text fields _default is system font with size 18.0_
		public static var font: UIFont = .systemFont(ofSize: 18)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		public static var backBarButtonIcon: UIImage?
	}
}

public extension Desk360.Config {
	struct Requests {
		private init() {}

	}

	struct Conversation {
		private init() {}

		/// Title
		public static var title: String?

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.backgroundColor

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Border width. _dafault is 0_
		public static var borderWidth: CGFloat = 0

		/// Border color.
		public static var borderColor: UIColor?

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.textColor

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.tintColor

		/// Font.
		public static var font: UIFont = Desk360.Config.font

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		public static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon

	}
}

public extension Desk360.Config.Requests {

	struct Create {
		private init() {}

		/// Background color
		public static var backgroundColor: UIColor = Desk360.Config.backgroundColor

		/// Corner radius
		public static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Buttons border width. _default is 0_
		public static var borderWidth: CGFloat = 0

		/// Buttons border color.
		public static var borderColor: UIColor?

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.textColor

		/// Placeholder text color.
		public static var PlaceholderTextColor: UIColor?

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.tintColor

		/// Font.
		public static var font: UIFont = Desk360.Config.font.withSize(18)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		public static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon

	}

	struct Listing {
		private init() {}

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.backgroundColor

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Buttons border width. _default is 0_
		public static var borderWidth: CGFloat = 0

		/// Buttons border color.
		public static var borderColor: UIColor?

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.textColor

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.tintColor

		/// Font.
		public static var font: UIFont = Desk360.Config.font.withSize(20)

		/// Font.
		public static var boldFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		public static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon
	}
}

public extension Desk360.Config.Requests.Create {

	/// Use `SupportConfig.Create.NameTextField` to set up the name text field in create request page in your application.
	struct NameTextField {
		private init() {}

		/// Text field icon.
		public static var icon: UIImage?

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Placeholder text color.
		public static var PlaceholderTextColor: UIColor? = Desk360.Config.Requests.Create.PlaceholderTextColor
	}

	/// Use `SupportConfig.Create.NameTextField` to set up the name text field in create request page in your application.
	struct SubjectTextField {
		private init() {}

		/// Text field icon.
		public static var icon: UIImage?

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Placeholder text color.
		public static var PlaceholderTextColor: UIColor? = Desk360.Config.Requests.Create.PlaceholderTextColor
	}

	/// Use `SupportConfig.Create.EmailTextField` to set up the email text field in create request page in your application.
	struct EmailTextField {
		private init() {}

		/// Text field icon.
		public static var icon: UIImage?

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Placeholder text color.
		public static var PlaceholderTextColor: UIColor? = Desk360.Config.Requests.Create.PlaceholderTextColor

	}

	// Use `SupportConfig.Create.DropDownListView` to set up the dropdown list in create request page in your application.
	struct DropDownListView {
		private init() {}

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		public static var textColor: UIColor = .white

		/// Border color.
		public static var borderColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Placeholder text color.
		public static var arrowColor: UIColor = .white

		/// Placeholder text color.
		public static var placeholderTextColor: UIColor = Desk360.Config.Requests.Create.PlaceholderTextColor ?? .white

		/// Selected row color.
		public static var selectedRowColor: UIColor? = Desk360.Config.Requests.Create.PlaceholderTextColor

		/// Row background  color.
		public static var rowBackgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Arrow Size
		public static var arrowSize: CGFloat = 20

		/// Border width
		public static var borderWidth: CGFloat = 1

		/// Corner Radius
		public static var cornerRadius: CGFloat = 5

		/// List Height
		public static var listHeight: CGFloat = 150

		/// List Height
		public static var rowHeight: CGFloat = 30
	}

	/// Use `SupportConfig.Create.MessageTextView` to set up the message text view in create request page in your application.
	struct MessageTextView {
		private init() {}

		/// Text view icon.
		public static var icon: UIImage?

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Border color.
		public static var borderColor: UIColor = Desk360.Config.Requests.Create.PlaceholderTextColor ?? UIColor.black.withAlphaComponent(0.5)

		/// Border width.
		public static var borderWidth: CGFloat = 1

	}

	/// Use `SupportConfig.Create.SendButton` to set up the send button in create request page in your application.
	struct SendButton {
		private init() {}

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Create.tintColor

		/// Tint color.
		public static var tintColor: UIColor = .white

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Requests.Create.cornerRadius

		/// Title font.
		public static var font: UIFont = Desk360.Config.Requests.Create.font

	}

}

public extension Desk360.Config.Requests.Listing {

	struct Placeholder {
		private init() {}

		/// Image.
		public static var image: UIImage?

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.tintColor

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.backgroundColor

	}

	/// Use `SupportConfig.Listing.NavItem` to set up the navigation item in request listing page in your application.
	struct NavItem {
		private init() {}

		/// Button icon.
		public static var icon: UIImage?

	}

	/// Use `SupportConfig.Listing.Cell` to set up request cells in request listing page in your application.
	struct Cell {
		private init() { }

		/// Cell background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.backgroundColor

		/// Cell title color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.tintColor

		/// Cell corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Requests.Listing.cornerRadius

		/// Bottom line color.
		public static var lineColor: UIColor = Desk360.Config.Requests.Listing.tintColor
	}
}

public extension Desk360.Config.Requests.Listing.Placeholder {

	/// Use `SupportConfig.Listing.Placeholder.Title` to set up the Placeholder title in request listing page in your application.
	struct Title {
		private init() {}

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Font.
		public static var font: UIFont = Desk360.Config.Requests.Listing.font

	}

	/// Use `SupportConfig.Listing.Placeholder.CreateButton` to set up the Placeholder create button in request listing page in your application.
	struct CreateButton {
		private init() {}

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.tintColor

		/// title color
		public static var titleColor: UIColor = Desk360.Config.Requests.Listing.backgroundColor

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Requests.Listing.cornerRadius

		/// Border width.
		public static var borderWidth: CGFloat = Desk360.Config.Requests.Listing.borderWidth

		/// Border color.
		public static var borderColor: UIColor? = Desk360.Config.Requests.Listing.borderColor

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.textColor

		/// Font
		public static var font: UIFont = Desk360.Config.Requests.Listing.font

	}
}

public extension Desk360.Config.Requests.Listing.Cell {
	/// Use `SupportConfig.Listing.Cell.Expired` to set up request expired cells in request listing page in your application.
	struct Expired {
		private init() {}

		/// Cell background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.Cell.tintColor

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		public static var titleTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell title text font.
		public static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell date font.
		public static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Open` to set up request open cells in request listing page in your application.
	struct Open {
		private init() {}

		/// Cell background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.Cell.tintColor

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		public static var titleTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell title text font.
		public static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell date font.
		public static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Read` to set up request read cells in request listing page in your application.
	struct Read {
		private init() {}

		/// Cell background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.Cell.tintColor

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		public static var titleTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell title text font.
		public static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell date font.
		public static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)
	}

	/// Use `SupportConfig.Listing.Cell.Unread` to set up request unread cells in request listing page in your application.
	struct Unread {
		private init() {}

		/// Cell background color.
		public static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		public static var tintColor: UIColor = Desk360.Config.Requests.Listing.Cell.tintColor

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		public static var titleTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell title text font.
		public static var titleFont: UIFont = Desk360.Config.Requests.Listing.boldFont

		/// Cell date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Requests.Listing.textColor

		/// Cell date font.
		public static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}
}

public extension Desk360.Config.Conversation {

	/// Use `SupportConfig.Conversation.Input` to set up the input bar in conversation page in your application.
	struct Input {
		private init() {}

		/// Bar height. _dafault is 66.0_
		public static var height: CGFloat = 66.0

		/// Bar maximum allowe height. _dafault is 200.0_
		public static var maxHeight: CGFloat = 200.0

		/// Bar background color.
		public static var backgroundColor: UIColor = Desk360.Config.Conversation.tintColor
	}

	/// Use `SupportConfig.Conversation.MessageCell` to set up message cells in conversation page in your application.
	struct MessageCell {
		private init() {}

		/// message text font.
		public static var messageFont: UIFont = Desk360.Config.Conversation.font.withSize(20)

		/// Message date font.
		public static var dateFont: UIFont = Desk360.Config.Conversation.font.withSize(14)

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Conversation.cornerRadius

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Conversation.backgroundColor

		/// Message text color.
		public static var messageTextColor: UIColor = Desk360.Config.Conversation.textColor

		/// Date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Conversation.textColor
	}

}

public extension Desk360.Config.Conversation.Input {

	/// Use `SupportConfig.Conversation.Input.TextView` to set up the text view in input bar in conversation page in your application.
	struct TextView {
		private init() {}
	}

	/// Use `SupportConfig.Conversation.Input.SendButton` to set up the send button in input bar in conversation page in your application.
	struct SendButton {
		private init() {}
	}

	/// Use `SupportConfig.Conversation.Input.CreateRequestButton` to set up the create request button in input bar in conversation page in your application.
	struct CreateRequestButton {
		private init() {}
	}

}

public extension Desk360.Config.Conversation.Input.TextView {

	/// Background color.
	static var backgroundColor: UIColor = Desk360.Config.Conversation.backgroundColor

	/// Font.
	static var font: UIFont = Desk360.Config.Conversation.font

	/// Tint color.
	static var tintColor: UIColor = Desk360.Config.Conversation.tintColor

	/// Text color.
	static var textColor: UIColor = Desk360.Config.Conversation.textColor

	/// Corner radius.
	static var cornerRadius: CGFloat = Desk360.Config.Conversation.cornerRadius

	/// Border width.
	static var borderWidth: CGFloat = 1

	/// Border color
	static var borderColor = Desk360.Config.Conversation.textColor

	/// Use `SupportConfig.Conversation.Input.TextView.Placeholder` to set up the text view's Placeholder in input bar in conversation page in your application.
	struct Placeholder {
		private init() {}
		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Conversation.textColor.withAlphaComponent(0.25)
	}

}

public extension Desk360.Config.Conversation.Input.SendButton {

	/// Tint color.
	static var tintColor: UIColor = Desk360.Config.Conversation.backgroundColor

	/// Button icon.
	static var icon: UIImage?

	/// Button title font.
	static var font: UIFont = Desk360.Config.Conversation.font

}

public extension Desk360.Config.Conversation.Input.CreateRequestButton {

	/// Background color
	static var backgroundColor: UIColor = Desk360.Config.Conversation.backgroundColor

	/// Tint color.
	static var tintColor: UIColor = Desk360.Config.Conversation.tintColor

	/// Button font.
	static var font: UIFont = Desk360.Config.Conversation.font

}

public extension Desk360.Config.Conversation.MessageCell {

	/// Use `SupportConfig.Conversation.MessageCell.Receiver` to set up the receiver message cells in conversation page in your application.
	struct Receiver {
		private init() {}

		/// Message font.
		public static var messageFont: UIFont = Desk360.Config.Conversation.MessageCell.messageFont

		/// Date font.
		public static var dateFont: UIFont = Desk360.Config.Conversation.MessageCell.dateFont

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Conversation.MessageCell.cornerRadius

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Conversation.MessageCell.backgroundColor

		/// Message text color.
		public static var messageTextColor: UIColor = Desk360.Config.Conversation.MessageCell.messageTextColor

		/// Date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Conversation.MessageCell.dateTextColor

	}

	/// Use `SupportConfig.Conversation.MessageCell.Sender` to set up the sender message cells in conversation page in your application.
	struct Sender {
		private init() {}

		/// Message font.
		public static var messageFont: UIFont = Desk360.Config.Conversation.MessageCell.messageFont

		/// Date font.
		public static var dateFont: UIFont = Desk360.Config.Conversation.MessageCell.dateFont

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Conversation.MessageCell.cornerRadius

		/// Background color.
		public static var backgroundColor: UIColor = Desk360.Config.Conversation.MessageCell.backgroundColor

		/// Message text color.
		public static var messageTextColor: UIColor = Desk360.Config.Conversation.MessageCell.messageTextColor

		/// Date text color.
		public static var dateTextColor: UIColor = Desk360.Config.Conversation.MessageCell.dateTextColor

	}
}
// swiftlint:enable nesting file_length
