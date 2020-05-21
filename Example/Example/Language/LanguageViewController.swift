//
//  LanguageViewController.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

protocol LanguageViewControllerDelegate: AnyObject {
	func setLanguage()
}

final class LanguageViewController: UIViewController, Layouting {
	typealias ViewType = LanguageView

	weak var delegate: LanguageViewControllerDelegate?

	var languages: [Language] = []

	override func loadView() {
		view = LanguageView.create()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		languages = Language.languages()
		layoutableView.tableView.delegate = self
		layoutableView.tableView.dataSource = self
		layoutableView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
	}

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return languages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(LanguageTableViewCell.self)
		cell.configure(for: languages[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let language = languages[indexPath.row]

		try? Stores.currentLanguage.save(language)

		self.dismiss(animated: true) {
			DispatchQueue.main.async {
				self.delegate?.setLanguage()
			}
		}
	}

}

// MARK: - Actions
extension LanguageViewController {

	@objc func didTapCloseButton() {
		self.dismiss(animated: true, completion: nil)
	}

}

