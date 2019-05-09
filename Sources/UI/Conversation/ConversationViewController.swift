//
//  ConversationViewController.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import UIKit

final class ConversationViewController: UIViewController {

	typealias ViewType = ConversationView
	override func loadView() {
		view = ViewType.create()
	}

}
