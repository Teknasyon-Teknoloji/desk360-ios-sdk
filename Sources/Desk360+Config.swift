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

	enum Theme: String {
		case light
		case dark
	}

	struct Config {
		private init() {}

		public static var theme: Theme = .light

		/// The background color for view controller. _default is #f3f3f3
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "f3f3f3")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()

		/// The text color for view controller. _default is white
		static var textColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .white
			case .dark:
				return .black
			}
		}()

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
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "f3f3f3")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()

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
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "F3F3F3")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()

		/// Corner radius
		public static var cornerRadius: CGFloat = Desk360.Config.cornerRadius

		/// Buttons border width. _default is 0_
		public static var borderWidth: CGFloat = 1

		/// Buttons border color.
		static var borderColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "A6A6A8")!
			case .dark:
				return UIColor.init(hex: "bfbfc1")!
			}
		}()

		/// Text color.
		static var textColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .black
			case .dark:
				return .white
			}
		}()

		/// Placeholder text color.
		static var PlaceholderTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "A6A6A8")!
			case .dark:
				return UIColor.init(hex: "A6A6A8")!
			}
		}()

		/// Tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "bababa")!
			case .dark:
				return .white
			}
		}()


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
		public static var borderWidth: CGFloat = 1

		/// Buttons border color.
		public static var borderColor: UIColor?

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.textColor

		/// Tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "f3f3f3")!
			case .dark:
				return .black
			}
		}()

		/// Font.
		public static var font: UIFont = Desk360.Config.font.withSize(20)


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
		public static var backgroundColor: UIColor = .clear

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
		public static var backgroundColor: UIColor = .clear

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
		public static var backgroundColor: UIColor = .clear

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Placeholder text color.
		public static var PlaceholderTextColor: UIColor? = Desk360.Config.Requests.Create.PlaceholderTextColor

	}

	// Use `SupportConfig.Create.DropDownListView` to set up the dropdown list in create request page in your application.
	struct DropDownListView {
		private init() {}

		/// Background color.
		static var backgroundColor: UIColor = Desk360.Config.Requests.Create.backgroundColor

		/// Text color.
		static var textColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "6e6e6e")!
			case .dark:
				return UIColor.init(hex: "cbcbcb")!
			}
		}()


		/// Border color.
		public static var borderColor: UIColor = UIColor.black.withAlphaComponent(0.5)

		/// Placeholder text color.
		public static var arrowColor: UIColor = .white

		/// DropDown list arrow icon.
		public static var arrowIcon: UIImage?

		/// DropDown list arrow icon.
		static var arrowTintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "58b0fa")!
			case .dark:
				return UIColor.init(hex: "cbcbcb")!
			}
		}()


		/// Placeholder text color.
		public static var placeholderTextColor: UIColor = UIColor.init(hex: "A6A6A8")!

		/// Selected row color.
		public static var selectedRowColor: UIColor? = .white

		/// Row background  color.
		public static var rowBackgroundColor: UIColor = .white

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
		public static var backgroundColor: UIColor = .clear

		/// Text color.
		public static var textColor: UIColor = Desk360.Config.Requests.Create.textColor

		/// Border color.
		public static var borderColor: UIColor = Desk360.Config.Requests.Create.PlaceholderTextColor

		/// Border width.
		public static var borderWidth: CGFloat = 1

	}

	/// Use `SupportConfig.Create.SendButton` to set up the send button in create request page in your application.
	struct SendButton {
		private init() {}

		/// Background color.
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "58B0FA")!
			case .dark:
				return UIColor.init(hex: "3b97e5")!
			}
		}()

		/// Tint color.
		public static var tintColor: UIColor = .white

		/// Corner radius.
		public static var cornerRadius: CGFloat = 20

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
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b5b5b7")!
			case .dark:
				return UIColor.init(hex: "d1d1d1")!
			}
		}()

		/// Tint color.
		static var desk360LabelTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "dcdcdc")!
			case .dark:
				return UIColor.init(hex: "626262")!
			}
		}()



		/// Background color.
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "F3F3F3")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()

	}

	/// Use `SupportConfig.Listing.NavItem` to set up the navigation item in request listing page in your application.
	struct NavItem {
		private init() {}

		/// Button icon.
		public static var icon: UIImage?

		// Tint color
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "5c5c5c")!
			case .dark:
				return .white
			}
		}()

	}

	/// Use `SupportConfig.Listing.Cell` to set up request cells in request listing page in your application.
	struct Cell {
		private init() { }

		/// Cell background color.
		public static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .white
			case .dark:
				return UIColor.init(hex: "3c3c3c")!
			}
		}()

		/// Cell title color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .black
			case .dark:
				return .white
			}
		}()

		/// Cell corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.Requests.Listing.cornerRadius

		/// Bottom line color.
		static var lineColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "D5D5D5")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()

	}
}

public extension Desk360.Config.Requests.Listing.Placeholder {

	/// Use `SupportConfig.Listing.Placeholder.Title` to set up the Placeholder title in request listing page in your application.
	struct Title {
		private init() {}

		/// Text color.
		static var textColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "868686")!
			case .dark:
				return UIColor.init(hex: "bababa")!
			}
		}()

		/// Font.
		public static var font: UIFont =  UIFont.systemFont(ofSize: 18, weight: .regular)

	}

	/// Use `SupportConfig.Listing.Placeholder.CreateButton` to set up the Placeholder create button in request listing page in your application.
	struct CreateButton {
		private init() {}

		/// Background color.
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "58b0fa")!
			case .dark:
				return UIColor.init(hex: "3b97e5")!
			}
		}()

		/// title color
		public static var titleColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .white
			case .dark:
				return .white
			}
		}()

		/// Corner radius.
		public static var cornerRadius: CGFloat = 20

		/// Border width.
		public static var borderWidth: CGFloat = 0

		/// Border color.
		public static var borderColor: UIColor? = .clear

		/// Tint color.
		public static var tintColor: UIColor = Desk360.Config.textColor

		/// Font
		public static var font: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold)

	}
}

public extension Desk360.Config.Requests.Listing.Cell {
	/// Use `SupportConfig.Listing.Cell.Expired` to set up request expired cells in request listing page in your application.
	struct Expired {
		private init() {}

		/// Cell background color.
		static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "a7b2c4")!
			case .dark:
				return UIColor.init(hex: "cecece")!
			}
		}()

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		static var titleTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "636363")!
			case .dark:
				return .white
			}
		}()

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b0b0b0")!
			case .dark:
				return UIColor.init(hex: "b0b0b0")!
			}
		}()

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Open` to set up request open cells in request listing page in your application.
	struct Open {
		private init() {}

		/// Cell background color.
		static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "a7b2c4")!
			case .dark:
				return UIColor.init(hex: "cecece")!
			}
		}()

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		static var titleTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "636363")!
			case .dark:
				return .white
			}
		}()

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b0b0b0")!
			case .dark:
				return UIColor.init(hex: "b0b0b0")!
			}
		}()

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)

	}

	/// Use `SupportConfig.Listing.Cell.Read` to set up request read cells in request listing page in your application.
	struct Read {
		private init() {}

		/// Cell background color.
		static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "a7b2c4")!
			case .dark:
				return UIColor.init(hex: "cecece")!
			}
		}()

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		static var titleTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "636363")!
			case .dark:
				return .white
			}
		}()
		
		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date text color.
		static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b0b0b0")!
			case .dark:
				return UIColor.init(hex: "b0b0b0")!
			}
		}()

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)
	}

	/// Use `SupportConfig.Listing.Cell.Unread` to set up request unread cells in request listing page in your application.
	struct Unread {
		private init() {}

		/// Cell background color.
		static var backgroundColor: UIColor = Desk360.Config.Requests.Listing.Cell.backgroundColor

		/// Cell tint color.
		static var tintColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "a7b2c4")!
			case .dark:
				return UIColor.init(hex: "cecece")!
			}
		}()

		/// Cell icon image.
		public static var icon: UIImage?

		/// Cell title text color.
		static var titleTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "2d2d2d")!
			case .dark:
				return .white
			}
		}()

		/// Cell title text font.
		static var titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)

		/// Cell date text color.
		static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b0b0b0")!
			case .dark:
				return .white
			}
		}()

		/// Cell date font.
		static var dateFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .bold)

	}
}

public extension Desk360.Config.Conversation {

	/// Use `SupportConfig.Conversation.Input` to set up the input bar in conversation page in your application.
	struct Input {
		private init() {}

		/// Bar height. _dafault is 66.0_
		public static var height: CGFloat = 75

		/// Bar maximum allowe height. _dafault is 200.0_
		public static var maxHeight: CGFloat = 200.0

		/// Bar background color.
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "f3f3f3")!
			case .dark:
				return UIColor.init(hex: "2b2b2b")!
			}
		}()


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
	static var backgroundColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return .clear
		case .dark:
			return .clear
		}
	}()

	/// Font.
	static var font: UIFont = .systemFont(ofSize: 18)

	/// Tint color.
	static var tintColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return .black
		case .dark:
			return .white
		}
	}()

	/// Text color.
	static var textColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return .black
		case .dark:
			return .white
		}
	}()

	/// Corner radius.
	static var cornerRadius: CGFloat = Desk360.Config.Conversation.cornerRadius

	/// Border width.
	static var borderWidth: CGFloat = 1

	/// Border color
	static var borderColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return UIColor.init(hex: "bfbfc1")!
		case .dark:
			return UIColor.init(hex: "6e6e6e")!
		}
	}()

	/// Use `SupportConfig.Conversation.Input.TextView.Placeholder` to set up the text view's Placeholder in input bar in conversation page in your application.
	struct Placeholder {
		private init() {}
		/// Text color.
		static var textColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "a6a6a8")!
			case .dark:
				return UIColor.init(hex: "a6a6a8")!
			}
		}()
	}

}

public extension Desk360.Config.Conversation.Input.SendButton {

	/// Tint color.
	static var tintColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return UIColor.init(hex: "436091")!
		case .dark:
			return .white
		}
	}()

	/// Button icon.
	static var icon: UIImage?

	/// Button title font.
	static var font: UIFont = Desk360.Config.Conversation.font

}

public extension Desk360.Config.Conversation.Input.CreateRequestButton {

	/// Background color
	static var backgroundColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return UIColor.init(hex: "58b0fa")!
		case .dark:
			return UIColor.init(hex: "3b97e5")!
		}
	}()

	/// Tint color.
	static var tintColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return .white
		case .dark:
			return .black
		}
	}()

	/// Text color.
	static var textColor: UIColor = {
		switch Desk360.Config.theme {
		case .light:
			return .white
		case .dark:
			return .white
		}
	}()

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
		public static var messageFont: UIFont = Desk360.Config.Conversation.MessageCell.messageFont

		/// Date font.
		public static var dateFont: UIFont = Desk360.Config.Conversation.MessageCell.dateFont

		/// Corner radius.
		public static var cornerRadius: CGFloat = Desk360.Config.Conversation.MessageCell.cornerRadius

		/// Background color.
		public static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .white
			case .dark:
				return UIColor.init(hex: "4f5155")!
			}
		}()

		/// Message text color.
		public static var messageTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "525a7e")!
			case .dark:
				return .white
			}
		}()

		/// Date text color.
		public static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "525a7e")!
			case .dark:
				return UIColor.init(hex: "9e9e9e")!
			}
		}()

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

		/// Background color.
		static var backgroundColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "436091")!
			case .dark:
				return UIColor.init(hex: "e5e5e5")!
			}
		}()

		/// Message text color.
		static var messageTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return .white
			case .dark:
				return .black
			}
		}()

		/// Date text color.
		static var dateTextColor: UIColor = {
			switch Desk360.Config.theme {
			case .light:
				return UIColor.init(hex: "b0b0b0")!
			case .dark:
				return UIColor.init(hex: "9e9e9e")!
			}
		}()

	}
}
// swiftlint:enable nesting file_length
