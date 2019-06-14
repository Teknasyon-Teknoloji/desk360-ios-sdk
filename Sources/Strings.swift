//
//  Strings.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import Foundation
import UIKit

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

		static var listinNavTitle: String {
			return "listing.nav.title".localize()
		}

		static var subjectTypeListPlaceHolder: String {
			return "create.form.request_type".localize()
		}

		static var createTitle: String {
			return "listing.nav.create".localize()
		}

		static var createNameTextFieldPlaceholder: String {
			return "create.form.name".localize()
		}

		static var createSubjectTextFieldPlaceholder: String {
			return "create.from.subject".localize()
		}

		static var createEmailTextFieldPlaceholder: String {
			return "create.form.email".localize()
		}

		static var createMessageTextViewPlaceholder: String {
			return "create.form.message".localize()
		}

		static var createMessageSendButtonTitle: String {
			return "create.form.submit".localize()
		}

		static var listingNavButtonTitle: String {
			return "listing.nav.title".localize()
		}

		static var listingPlaceholderLabelTitle: String {
			return "listing.placeholder.title".localize()
		}

		static var listingPlaceholderButtonTitle: String {
			return "listing.placeholder.submit".localize()
		}

		static var conversationMessageTextViewPlaceholder: String {
			return "create.form.message".localize()
		}

		static var conversationSendButtonTitle: String {
			return "Message"
		}

		static var conversationExpiredButtonTitle: String {
			return "Create New Request"
		}

	}

}
