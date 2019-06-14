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

	override func viewDidLoad() {
		super.viewDidLoad()

		configureDesk360()
	}

	@IBAction func didTapPresentButton(_ sender: UIButton) {
//		Desk360.present(in: self)
		Desk360.show(on: self, animated: true)
	}

	@IBAction func didTapPushButton(_ sender: UIButton) {
		Desk360.show(on: self, animated: true)
	}

}

// MARK: - Configure
extension ViewController {

	func configureDesk360() {
		Desk360.Config.theme = .light
	}

}
