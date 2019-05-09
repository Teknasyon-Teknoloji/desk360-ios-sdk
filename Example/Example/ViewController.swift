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

	@IBAction func didTapPresentButton(_ sender: UIButton) {
		Desk360.shared.present(in: self)
	}

	@IBAction func didTapPushButton(_ sender: UIButton) {
		Desk360.shared.push(on: self)
	}

}

extension ViewController: Desk360Delegate {

}
