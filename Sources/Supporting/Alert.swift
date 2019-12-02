//
//  Alert.swift
//  Desk360
//
//  Created by samet on 18.06.2019.
//

import UIKit

final class Alert {

	static func showAlert(viewController: UIViewController, title: String, message: String, dissmis: Bool ) {

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

	static func showAlertForRegister(viewController: UIViewController, title: String, message: String, dissmis: Bool ) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "ok.button".localize(), style: UIAlertAction.Style.default, handler: { _ in }))

		viewController.present(alert, animated: true, completion: nil)

	}
}
