//
//  Desk360+Config.swift
//  Desk360
//
//  Created by Omar on 5/16/19.
//

import Foundation
import UIKit

/// Use `Desk360.Config` to set up the contact us page in your application.
public extension Desk360 {

	struct Config {
		private init() {}

		static let bundle = Bundle.assetsBundle

		/// The corner radius for buttons. _default is 8_
		static var cornerRadius: CGFloat = 8

		/// The font for labels and text fields _default is system font with size 18.0_
		static var font: UIFont = .systemFont(ofSize: 18)

		/// The icon to be used instead of system's default back icon in the navigation bar. _default is nil_
		static var backBarButtonIcon: UIImage?

	}
}

public extension Desk360.Config {

	struct Images {
		private init() {}

		static func createImage(resources: String) -> UIImage {
			guard let path = Desk360.Config.bundle?.path(forResource: resources, ofType: "png") else { return UIImage() }
			guard let image = UIImage(contentsOfFile: path) else { return UIImage()}
			return image.withRenderingMode(.alwaysTemplate)
		}

        static func createImageOriginal(resources: String) -> UIImage {
            guard let path = Desk360.Config.bundle?.path(forResource: resources, ofType: "png") else { return UIImage() }
            guard let image = UIImage(contentsOfFile: path) else { return UIImage()}
            return image.withRenderingMode(.alwaysOriginal)
        }

		static var desk360Logo: UIImage = {
			guard let path = Desk360.Config.bundle?.path(forResource: "Images/desk360Logo", ofType: "png") else { return UIImage() }
			guard let image = UIImage(contentsOfFile: path) else { return UIImage() }
			return image
		}()

		static var playIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/play")
		}()

		static var checkMarkPassive: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/checkMarkPassive")
		}()

		static var checkMarkActive: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/checkMarkActive")
		}()

		static var pauseIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/pause")
		}()

		static var arrowIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/arrowLight")
		}()

		static var attachmentIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/attachment")
		}()

		static var successIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/successIcon")
		}()

		static var emptyIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/emptyIcon")
		}()

		static var image: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/supportCreateLight")
		}()

		static var closeIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/closeLight")
		}()

		static var cancelIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/cancel")
		}()

		static var addIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/iconNavigationbarAdd")
		}()

		static var backIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/backButtonLight")
		}()

		static var readIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/readLight")
		}()

		static var unreadIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/unreadDark")
		}()

		static var sendIcon: UIImage = {
			return Desk360.Config.Images.createImage(resources: "Images/sendLight")
		}()

        static var attachIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/attach")
        }()

        static var attachRemoveIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/attachRemove")
        }()

        static var arrowDownIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/arrowDown")
        }()

        static var arrowUpIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/arrowUp")
        }()

        static var senderDownloadFile: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/filedownloadsender")
        }()
        static var receiverDownloadFile: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/filedownloadreceiver")
        }()

        static var agreementCheckIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/agreementCheck")
        }()

        static var agreementUnCheckIcon: UIImage = {
            return Desk360.Config.Images.createImageOriginal(resources: "Images/agreementUnCheck")
        }()
	}

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

public extension Desk360.Config.Requests.Listing {

	/// Use `SupportConfig.Listing.Cell` to set up request cells in request listing page in your application.
	struct Cell {
		private init() { }

		/// Cell corner radius.
		static var cornerRadius: CGFloat = Desk360.Config.Requests.Listing.cornerRadius

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

		/// Cell title text font.
		static var titleFont: UIFont = Desk360.Config.Requests.Listing.font

		/// Cell date font.
		static var dateFont: UIFont = Desk360.Config.Requests.Listing.font.withSize(12)
	}

	/// Use `SupportConfig.Listing.Cell.Unread` to set up request unread cells in request listing page in your application.
	struct Unread {
		private init() {}

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
		static var dateFont: UIFont = Desk360.Config.Conversation.font.withSize(10)

		/// Corner radius.
		static var cornerRadius: CGFloat = 19

        /// Message filename font.
        static var fileNameFont: UIFont = Desk360.Config.Conversation.font.withSize(14)
	}

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
