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

		static var mySupportRequest: String {
			return "listing.supports.title".localize()
		}

		static var listingNavTitle: String {
			return "listing.nav.title".localize()
		}

	}

}
