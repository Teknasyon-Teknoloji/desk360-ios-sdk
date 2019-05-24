//
//  Strings.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import Foundation

/// Common local strings to use internally in Desk360.
public extension Desk360 {
	struct Strings {
		private init() {}
	}
}

public extension Desk360.Strings {

	struct Maintenance {
		private init() {}

		static var title: String {
			return "Under Maintenance"
		}

		static var message: String {
			return "Sorry we are down for maintenance. We will be back online shortly."
		}

	}

	struct Unauthorized {
		private init() {}

		static var title: String {
			return Common.unauthorized
		}
		static var message: String {
			return "Please restart the application and try again."
		}
	}

	struct Common {
		private init() {}

		static var tryAgain: String {
			return "Try Again"
		}

		static var update: String {
			return "Update"
		}

		static var cancel: String {
			return "Cancel"
		}

		static var unauthorized: String {
			return "Unauthorized"
		}

		static var unknownError: String {
			return "Unknown Server Error"
		}

	}

	struct Support {
		private init() {}

		static var subjectTypeListPlaceHolder: String {
			return "Please Select"
		}

		static var createTitle: String {
			return "Contact Us"
		}

		static var createNameTextFieldPlaceholder: String {
			return "Name"
		}

		static var createSubjectTextFieldPlaceholder: String {
			return "Subject"
		}

		static var createEmailTextFieldPlaceholder: String {
			return "Email Address"
		}

		static var createMessageTextViewPlaceholder: String {
			return "Your Message"
		}

		static var createMessageSendButtonTitle: String {
			return "Send Message"
		}

		static var listingNavButtonTitle: String {
			return "Create Request"
		}

		static var listingPlaceholderLabelTitle: String {
			return "You have made no support calls yet."
		}

		static var listingPlaceholderButtonTitle: String {
			return "Create a support task"
		}

		static var conversationMessageTextViewPlaceholder: String {
			return "Message"
		}

		static var conversationSendButtonTitle: String {
			return "Message"
		}

		static var conversationExpiredButtonTitle: String {
			return "Create New Request"
		}

	}

}
