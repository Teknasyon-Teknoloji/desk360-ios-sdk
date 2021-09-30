//
//  DemoViewController.swift
//  Example
//
//  Created by samet on 16.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit
// import IQKeyboardManager

final class DemoViewController: UIViewController, Layouting {
	typealias ViewType = DemoView

	override func loadView() {
		view = DemoView.create()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.tableView.delegate = self
		layoutableView.tableView.dataSource = self
	}

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DemoViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DemoItem.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(DemoTableViewCell.self)
		cell.configure(for: DemoItem.allCases[indexPath.row])
		cell.segmentedControl.addTarget(self, action: #selector(didChangedSegmentedControl), for: .valueChanged)
		cell.switchControl.addTarget(self, action: #selector(didChangedSwitchControl), for: .valueChanged)
		cell.switchControl.tag = indexPath.row
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch DemoItem(indexPath: indexPath) {
		case .language:
			guard !(Stores.useDeviceLanguage.object ?? false) else { return }
			guard let cell = tableView.cellForRow(at: indexPath) as? DemoTableViewCell else { return }
			guard cell.switchControl.isOn else { return }
			let languageViewController = LanguageViewController()
			languageViewController.delegate = self
			self.present(languageViewController, animated: true, completion: nil)
		default:
			break
		}
	}

}

// MARK: - LanguageViewControllerDelegate
extension DemoViewController: LanguageViewControllerDelegate {

	func setLanguage() {
		layoutableView.tableView.reloadData()
	}

}

// MARK: - Actions
extension DemoViewController {

	@objc func didChangedSegmentedControl(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			try? Stores.environment.save("test")
		} else {
			try? Stores.environment.save("production")
		}
		layoutableView.tableView.reloadData()
	}

	@objc func didChangedSwitchControl(_ sender: UISwitch) {

		switch sender.tag {
		case 3:
			try? Stores.useDeviceLanguage.save(sender.isOn)
			let languages = Language.languages()
			let language = languages.filter({$0.code == Locale.current.languageCode})
			if language.isEmpty {
				try? Stores.currentLanguage.save(Language.language(id: 2))
			} else {
				try? Stores.currentLanguage.save(language.first)
			}
		case 1:
			try? Stores.useJsonData.save(sender.isOn)
		default:
			break
		}
		layoutableView.tableView.reloadData()
	}

}

extension DemoViewController {

	func setIQKeyboardSettings() {
//		IQKeyboardManager.shared().isEnabled = false
//		IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
//		IQKeyboardManager.shared().shouldResignOnTouchOutside = true
//		IQKeyboardManager.shared().keyboardDistanceFromTextField = 10.0
//		IQKeyboardManager.shared().isEnableAutoToolbar = false
	}
}
