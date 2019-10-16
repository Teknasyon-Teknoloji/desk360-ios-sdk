//
//  CreateRequestViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

final class CreateRequestViewController: UIViewController, Layouting, UIGestureRecognizerDelegate {

	typealias ViewType = CreateRequestView
	override func loadView() {
		view = ViewType.create()
	}

	var checkLastClass: Bool?

	convenience init(checkLastClass: Bool) {
		self.init()
		self.checkLastClass = checkLastClass
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutableView.sendButton.addTarget(self, action: #selector(didTapSendRequestButton), for: .touchUpInside)
		registerForKeyboardEvents()

		guard let check = checkLastClass, check else { return }
		let count = navigationController?.viewControllers.count ?? 0
		navigationController?.viewControllers.removeSubrange(count-2..<count-1)

//		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = Desk360.Strings.Support.listingNavTitle

		fetchTicketType()

		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self
		navigationItem.rightBarButtonItem = nil

		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))
//		}
	}

	@objc private func didTapSendRequestButton() {

		checkChangeFrame()
		guard let name = layoutableView.nameTextField.trimmedText, name.count > 2 else {
			layoutableView.nameErrorLabel.isHidden = false
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
			layoutableView.nameTextField.shake()
			layoutableView.nameTextField.becomeFirstResponder()
			checkChangeFrame()
			return
		}

		layoutableView.nameErrorLabel.isHidden = true

		guard let email = layoutableView.emailTextField.emailAddress else {
			layoutableView.emailErrorLabel.isHidden = false
			layoutableView.scrollView.setContentOffset(CGPoint(x: 0, y: UITextField.preferredHeight), animated: true)
			layoutableView.emailTextField.shake()
			layoutableView.emailTextField.becomeFirstResponder()
			checkChangeFrame()
			return
		}

		checkChangeFrame()
		layoutableView.nameErrorLabel.isHidden = true

		guard layoutableView.dropDownListView.getSelectedIndex != -1 else {
			layoutableView.dropDownListView.shake()
			layoutableView.dropDownListView.showList()
			return
		}

		guard let message = layoutableView.messageTextView.trimmedText, message.count > 0 else {
			layoutableView.messageTextViewErrorLabel.isHidden = false
			layoutableView.messageTextView.shake()
			layoutableView.messageTextView.becomeFirstResponder()
			return
		}
		layoutableView.messageTextViewErrorLabel.isHidden = true

		let ticketTypes = layoutableView.ticketTypes
		guard ticketTypes.count > 0 else { return }
		let ticketTypeId = ticketTypes[layoutableView.dropDownListView.getSelectedIndex].id
		sendRequest(name: name, email: email, ticketType: String(ticketTypeId), message: message)
	}

	func checkChangeFrame() {
		HADropDown.frameChange = 0
		if layoutableView.nameErrorLabel.isHidden == false && layoutableView.emailErrorLabel.isHidden == false {
			HADropDown.frameChange = UITextField.preferredHeight
		} else if layoutableView.nameErrorLabel.isHidden && layoutableView.emailErrorLabel.isHidden {
			HADropDown.frameChange = 0
		} else {
			HADropDown.frameChange = UITextField.preferredHeight * 0.5
		}
	}

	@objc
	func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}

}

// MARK: - KeyboardObserving
extension CreateRequestViewController: KeyboardObserving {

	func keyboardWillShow(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillShow(notification)
	}

	func keyboardWillHide(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillHide(notification)
	}

	func keyboardDidHide(_ notification: KeyboardNotification?) {}
	func keyboardDidShow(_ notification: KeyboardNotification?) {}
	func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {
		layoutableView.keyboardWillChangeFrame(notification)
	}
	func keyboardDidChangeFrame(_ notification: KeyboardNotification?) {}

}

// MARK: - Networking
private extension CreateRequestViewController {

	func fetchTicketType() {

		Desk360.apiProvider.request(.ticketTypeList) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				if error.response?.statusCode == 400 {
					Desk360.register()
					Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: false)
				print(error.localizedDescription)
			case .success(let response):
				guard let ticketTypes = try? response.map(DataResponse<[TicketType]>.self) else { return }
				guard let ticketsTypes = ticketTypes.data else { return }
				self.layoutableView.ticketTypes.removeAll()
				self.layoutableView.ticketTypes = ticketsTypes
				self.layoutableView.setTicketType(ticketTypes: ticketsTypes)
			}
		}
	}

	func sendRequest(name: String, email: String, ticketType: String, message: String) {
		let request = TicketRequest(name: name, email: email, message: message, type_id: ticketType, source: "App", platform: "iOS", country_code: Locale.current.countryCode)

		layoutableView.endEditing(true)
		layoutableView.setLoading(true)
		Desk360.apiProvider.request(.create(request)) { [weak self] result in
			guard let self = self else { return }
			self.layoutableView.setLoading(false)
			switch result {
			case .failure(let error):
				print(error.localizedServerDescription)
				if error.response?.statusCode == 400 {
					Desk360.register()
					Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlert(viewController: self, title: "Desk360", message: "connection.error.message".localize(), dissmis: false)
			case .success:
				self.navigationController?.popViewController(animated: true)
			}
		}
	}

}
