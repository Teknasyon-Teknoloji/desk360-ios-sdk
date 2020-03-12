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

	var jsonObject: [String: Any]? = nil
	var deviceId: String?
	var	environment: Desk360Environment = .test


	override func viewDidLoad() {
		super.viewDidLoad()

		configureDesk360()
	}

	@IBAction func didTapShowWithJsonData(_ sender: Any) {
		jsonObject = [
			"app": "Demo App",
			"device Id": UIDevice.current.identifierForVendor!.uuidString
		]

		showDesk360()
	}

	@IBAction func didTapShowWithNullDeviceId(_ sender: Any) {

	}

	@IBAction func didTapPresentButton(_ sender: UIButton) {
		showDesk360()
	}

	@IBAction func didTapPushButton(_ sender: UIButton) {
		Desk360.show(on: self, animated: true)
	}

}

// MARK: - Configure
extension ViewController {

	func configureDesk360() {

	}

}

// MARK: - Helpers
extension ViewController {

	func showDesk360() {
		#if DEBUG
		let environment: Desk360Environment = .test
		#else
		let environment: Desk360Environment = .production
		#endif
		Desk360.start(appId: "oFkDNLOatwreoPZp43EWRhDdbGGBbgi8", environment: environment, language: "en", jsonInfo: jsonObject)
		jsonObject = nil
		Desk360.show(on: self, animated: true)
	}

}
