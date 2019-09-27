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

	enum ThemeType: String {
		case light
		case dark
	}

	struct Config {
		private init() {}

		static let bundle = Bundle.assetsBundle

		public static var theme: ThemeType = .light {
			didSet {
				switch theme {
				case .light:
					Config.currentTheme = LightTheme()

				case .dark:
					Config.currentTheme = DarkTheme()
				}
			}
		}

		public private(set) static var currentTheme: DeskTheme = LightTheme()

		/// The corner radius for buttons. _default is 8_
		static var cornerRadius: CGFloat = 8

		/// The font for labels and text fields _default is system font with size 18.0_
		static var font: UIFont = .systemFont(ofSize: 18)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		static var backBarButtonIcon: UIImage?
	}
}

public extension Desk360.Config {
	struct Requests {
		private init() {}

	}

	struct Conversation {
		private init() {}

		/// Title
		static var title: String?

		/// Corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Border width. _dafault is 0_
		static var borderWidth: CGFloat = 0

		/// Font.
		static var font: UIFont = Desk360.Config.font

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon

	}
}

public extension Desk360.Config.Requests {

	struct Create {
		private init() {}

		/// Corner radius
		static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Buttons border width. _default is 0_
		static var borderWidth: CGFloat = 1

		/// Font.
		static var font: UIFont = Desk360.Config.font.withSize(18)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon

	}

	struct Listing {
		private init() {}

		/// Corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Buttons border width. _default is 0_
		static var borderWidth: CGFloat = 1

		/// Font.
		static var font: UIFont = Desk360.Config.font.withSize(20)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		static var backBarButtonIcon: UIImage? = Desk360.Config.backBarButtonIcon
	}
}

public extension Desk360.Config.Requests.Create {

	/// Use `SupportConfig.Create.NameTextField` to set up the name text field in create request page in your application.
	struct NameTextField {
		private init() {}

		/// Text field icon.
		static var icon: UIImage?

	}

	/// Use `SupportConfig.Create.EmailTextField` to set up the email text field in create request page in your application.
	struct EmailTextField {
		private init() {}

		/// Text field icon.
		static var icon: UIImage?

	}

	// Use `SupportConfig.Create.DropDownListView` to set up the dropdown list in create request page in your application.
	struct DropDownListView {
		private init() {}

		/// DropDown list arrow icon.
		static var arrowIcon: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/arrowLight", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/arrowDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

		/// Arrow Size
		static var arrowSize: CGFloat = 20

		/// Border width
		static var borderWidth: CGFloat = 1

		/// Corner Radius
		static var cornerRadius: CGFloat = 5

		/// List Height
		static var listHeight: CGFloat = 150

		/// List Height
		static var rowHeight: CGFloat = 30
	}

	/// Use `SupportConfig.Create.MessageTextView` to set up the message text view in create request page in your application.
	struct MessageTextView {
		private init() {}

		/// Text view icon.
		static var icon: UIImage?

		/// Border width.
		static var borderWidth: CGFloat = 1

	}

	/// Use `SupportConfig.Create.SendButton` to set up the send button in create request page in your application.
	struct SendButton {
		private init() {}

		/// Corner radius.
		static var cornerRadius: CGFloat = 20

		/// Title font.
		static var font: UIFont = Desk360.Config.Requests.Create.font

	}

}

public extension Desk360.Config.Requests.Listing {

	struct Placeholder {
		private init() {}

		/// Image.
		static var image: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/supportCreateLight", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/supportCreateDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

	}

	/// Use `SupportConfig.Listing.NavItem` to set up the navigation item in request listing page in your application.
	struct NavItem {
		private init() {}
		/// Back button icon.
		static var closeIcon: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/closeLight", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/closeDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

		/// Add button icon.
		static var addIcon: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/iconNavigationbarAdd", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/iconNavigationbarAddDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

	}

	/// Use `SupportConfig.Listing.Cell` to set up request cells in request listing page in your application.
	struct Cell {
		private init() { }

		/// Cell corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.Requests.Listing.cornerRadius

	}
}

public extension Desk360.Config.Requests.Listing.Placeholder {

	/// Use `SupportConfig.Listing.Placeholder.Title` to set up the Placeholder title in request listing page in your application.
	struct Title {
		private init() {}

		/// Font.
		static var font: UIFont =  UIFont.systemFont(ofSize: 18, weight: .regular)

	}

	/// Use `SupportConfig.Listing.Placeholder.CreateButton` to set up the Placeholder create button in request listing page in your application.
	struct CreateButton {
		private init() {}

		/// Corner radius.
		static var cornerRadius: CGFloat = 20

		/// Border width.
		static var borderWidth: CGFloat = 0

		/// Font
		static var font: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold)

	}
}

public extension Desk360.Config.Requests.Listing.Cell {
	/// Use `SupportConfig.Listing.Cell.Expired` to set up request expired cells in request listing page in your application.
	struct Expired {
		private init() {}

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Open` to set up request open cells in request listing page in your application.
	struct Open {
		private init() {}

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Read` to set up request read cells in request listing page in your application.
	struct Read {
		private init() {}

		/// Cell icon image.
		static var icon: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/readLight", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/readDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)
	}

	/// Use `SupportConfig.Listing.Cell.Unread` to set up request unread cells in request listing page in your application.
	struct Unread {
		private init() {}

		/// Cell icon image.
		static var icon: UIImage = {
			switch Desk360.Config.theme {
			case .light:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/unreadLight", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			case .dark:
				guard let path = Desk360.Config.bundle?.path(forResource: "Images/unreadDark", ofType: "png") else { return UIImage() }
				let image = UIImage(contentsOfFile: path)!
				return image
			}
		}()

		/// Cell title text font.
		static var titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)

		/// Cell date font.
		static var dateFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .bold)

	}
}

public extension Desk360.Config.Conversation {

	/// Use `SupportConfig.Conversation.Input` to set up the input bar in conversation page in your application.
	struct Input {
		private init() {}

		/// Bar height. _dafault is 66.0_
		static var height: CGFloat = 75

		/// Bar maximum allowe height. _dafault is 200.0_
		static var maxHeight: CGFloat = 200.0

	}

	/// Use `SupportConfig.Conversation.MessageCell` to set up message cells in conversation page in your application.
	struct MessageCell {
		private init() {}

		/// message text font.
		static var messageFont: UIFont = Desk360.Config.Conversation.font.withSize(20)

		/// Message date font.
		static var dateFont: UIFont = Desk360.Config.Conversation.font.withSize(14)

		/// Corner radius.
		static var cornerRadius: CGFloat = 19
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

	/// Font.
	static var font: UIFont = .systemFont(ofSize: 18)

	/// Corner radius.
	static var cornerRadius: CGFloat = Desk360.Config.Conversation.cornerRadius

	/// Border width.
	static var borderWidth: CGFloat = 1

}

public extension Desk360.Config.Conversation.Input.SendButton {

	/// Button icon.
	static var icon: UIImage = {
		switch Desk360.Config.theme {
		case .light:
			guard let path = Desk360.Config.bundle?.path(forResource: "Images/sendLight", ofType: "png") else { return UIImage() }
			let image = UIImage(contentsOfFile: path)!
			return image
		case .dark:
			guard let path = Desk360.Config.bundle?.path(forResource: "Images/sendDark", ofType: "png") else { return UIImage() }
			let image = UIImage(contentsOfFile: path)!
			return image
		}
	}()

	/// Button title font.
	static var font: UIFont = Desk360.Config.Conversation.font

}

public extension Desk360.Config.Conversation.Input.CreateRequestButton {

	/// Button font.
	static var font: UIFont = Desk360.Config.Conversation.font

	/// Button corner radius
	static var cornerRadius: CGFloat = 20

}

public extension Desk360.Config.Conversation.MessageCell {

	/// Use `SupportConfig.Conversation.MessageCell.Receiver` to set up the receiver message cells in conversation page in your application.
	struct Receiver {
		private init() {}

		/// Message font.
		static var messageFont: UIFont = Desk360.Config.Conversation.MessageCell.messageFont

		/// Date font.
		static var dateFont: UIFont = Desk360.Config.Conversation.MessageCell.dateFont

		/// Corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.Conversation.MessageCell.cornerRadius

	}

	/// Use `SupportConfig.Conversation.MessageCell.Sender` to set up the sender message cells in conversation page in your application.
	struct Sender {
		private init() {}

		/// Message font.
		static var messageFont: UIFont = Desk360.Config.Conversation.MessageCell.messageFont

		/// Date font.
		static var dateFont: UIFont = Desk360.Config.Conversation.MessageCell.dateFont

		/// Corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.Conversation.MessageCell.cornerRadius

	}
}
// swiftlint:enable nesting file_length
