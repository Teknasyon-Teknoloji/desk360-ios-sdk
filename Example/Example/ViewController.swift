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

	@IBOutlet weak var environmentSwitchButton: UISwitch!
	@IBOutlet weak var languageTypeSwitchButton: UISwitch!
	var jsonObject: [String: Any]? = nil
	var deviceId: String?
    var	environment: Desk360Environment = .sandbox
	var appId: String = ""
	var language: String = ""

	override func viewDidLoad() {
		super.viewDidLoad()

		configureDesk360()
	}

	@IBAction func didTapShowWithJsonData(_ sender: Any) {
		jsonObject = [
			"app": "Demo App",
			"device Id": UIDevice.current.identifierForVendor!.uuidString
		]
		appId = "oFkDNLOatwreoPZp43EWRhDdbGGBbgi8"

		showDesk360()
	}

	@IBAction func environmentSwitchValueChanged(_ sender: Any) {
        environment = environmentSwitchButton.isOn ? .sandbox : .production
	}
	@IBAction func didTapShowWithWrongAppId(_ sender: Any) {
		showDesk360()
	}

	@IBAction func didTapPresentButton(_ sender: UIButton) {
		appId = "oFkDNLOatwreoPZp43EWRhDdbGGBbgi8"
		showDesk360()
	}

	@IBAction func didTapPushButton(_ sender: UIButton) {
//		Desk360.show(on: self, animated: true)
		print(Stores.generateRandomString())
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
		Desk360.start(appId: appId, environment: environment, language: "en", jsonInfo: jsonObject)
		jsonObject = nil
		appId = ""
		Desk360.show(on: self, animated: true)
	}

}
