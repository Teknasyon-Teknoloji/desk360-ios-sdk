//
//  CreateViewController.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import UIKit

final class CreateViewController: UIViewController {

	typealias ViewType = CreateView
	override func loadView() {
		view = ViewType.create()
	}

}
