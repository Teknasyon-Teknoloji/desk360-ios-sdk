//
//  Alert.swift
//  Desk360
//
//  Created by samet on 18.06.2019.
//

import UIKit

enum AlertType {
    case info
    case warning
    case error
    case success
}

enum AlertButtonType: String {
    case ok
    case cancel
	case tryAgain

    var localized: String {
        switch self {
        case .ok:
            return "ok.button".localize()
        case .cancel:
            return "cancel.button".localize()
		case .tryAgain:
			return "try.again.button".localize()
        }
    }
}

final class Alert {

	static let shared = Alert()
	
	/// Showing alert. After the alert is closed, the page is also closed.
	/// - Parameters:
	///   - viewController: A viewcontroller to present alert on it.
	///   - title: Alert's title
	///   - message: Alert's message
	///   - dissmis: If this value is true page will dismiss. If this value is false page will poping.
	static func showAlertWithDismiss(viewController: UIViewController, title: String, message: String, dissmis: Bool ) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "ok.button".localize(), style: UIAlertAction.Style.default, handler: { _ in
			if dissmis {
				viewController.dismiss(animated: true, completion: nil)
			} else {
				viewController.navigationController?.popViewController(animated: true)
			}

		}))

		viewController.present(alert, animated: true, completion: nil)

	}
	
	/// Showing alert method.
	/// - Parameters:
	///   - viewController: A viewcontroller to present alert on it.
	///   - title: Alert's title
	///   - message: Alert's message
	static func showAlert(viewController: UIViewController, title: String, message: String ) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "ok.button".localize(), style: UIAlertAction.Style.default, handler: { _ in }))

		viewController.present(alert, animated: true, completion: nil)

	}
	
	/// Showing alert method.
	/// - Parameters:
	///   - viewController: A viewcontroller to present alert on it.
	///   - alertType: Alert's type
	///   - title: Alert's title
	///   - message: Alert's message
	///   - buttons: Alert's buttons
	///   - dismissAfter: if set this value alert will wait before close this time
	///   - completion: completion action
	func showAlert(viewController: UIViewController, withType alertType: AlertType? = .info, title: String? = "", message: String, buttons: [String]? = nil, dismissAfter: Double? = nil, completion: ((Int) -> Void)! = nil) {

		let alert = UIAlertController(title: "Desk360", message: "connection.error.message".localize(), preferredStyle: UIAlertController.Style.alert)

		let currentButtons = buttons ?? ["ok.button".localize()]

		var type = UIAlertAction.Style.default

		currentButtons.enumerated().forEach { index, value in
			if value == "connection.error.message".localize() {
				type = .cancel
			}
			alert.addAction(UIAlertAction(title: value, style: type, handler: { _ in
				completion(index + 1)
			}))
		}

		viewController.present(alert, animated: true, completion: nil)
	}

}
