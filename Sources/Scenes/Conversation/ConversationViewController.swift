//
//  ConversationViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import Result

final class ConversationViewController: UIViewController, Layouting, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

	var request: Ticket!
	convenience init(request: Ticket) {
		self.init()
		self.request = request
	}

	typealias ViewType = ConversationView
	override func loadView() {
		view = ViewType.create()
	}

	var additionalBottomInset: CGFloat = 0 {
		didSet {
			let delta = additionalBottomInset - oldValue
			tableViewBottomInset += delta
		}
	}

	var tableViewBottomInset: CGFloat = 0 {
		didSet {
			layoutableView.tableView.contentInset.bottom = tableViewBottomInset
			layoutableView.tableView.scrollIndicatorInsets.bottom = tableViewBottomInset
		}
	}

	override var inputAccessoryView: UIView? {
		let view = layoutableView.conversationInputView
		view.delegate = self
		view.configure(for: request)
		return view
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}

	var attachment: URL?

	func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		scrollToBottom(animated: true)
		return false
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		registerForKeyboardEvents()
		layoutableView.tableView.dataSource = self
		layoutableView.tableView.delegate = self
		layoutableView.conversationInputView.delegate = self

		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()

		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

		layoutableView.conversationInputView.createRequestButton.addTarget(self, action: #selector(didTapNewRequestButton), for: .touchUpInside)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self

		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))

		configure()

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		layoutableView.setLoading(true)
		readRequest(request)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableViewBottomInset = requiredInitialScrollViewBottomInset()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		layoutableView.conversationInputView.textView.resignFirstResponder()
		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()
	}

	@objc
	private func handleKeyboardDidChangeState(_ notification: Notification) {
		guard let keyboardStartFrameInScreenCoords = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
		guard !keyboardStartFrameInScreenCoords.isEmpty else { return }
		guard let keyboardEndFrameInScreenCoords = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		let keyboardEndFrame = view.convert(keyboardEndFrameInScreenCoords, from: view.window)

		let newBottomInset = requiredScrollViewBottomInset(forKeyboardFrame: keyboardEndFrame)
		let differenceOfBottomInset = newBottomInset - tableViewBottomInset

		if  differenceOfBottomInset != 0 {
			let contentOffset = CGPoint(x: layoutableView.tableView.contentOffset.x, y: layoutableView.tableView.contentOffset.y + differenceOfBottomInset)
			layoutableView.tableView.setContentOffset(contentOffset, animated: false)
		}

		tableViewBottomInset = newBottomInset
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return request.messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = request.messages[indexPath.row]

		if message.isAnswer {
			let cell = tableView.dequeueReusableCell(SenderMessageTableViewCell.self)
			cell.configure(for: request.messages[indexPath.row])
			return cell
		}

		let cell = tableView.dequeueReusableCell(ReceiverMessageTableViewCell.self)
		cell.configure(for: request.messages[indexPath.row], indexPath, attachment)
		return cell
	}

}

// MARK: - ConversationInputViewDelegate
extension ConversationViewController: InputViewDelegate {

	func inputView(_ view: InputView, didTapCreateRequestButton button: UIButton) {
//		delegate?.conversationViewController(self, didTapCreateRequestButton: button)
	}

	func inputView(_ view: InputView, didTapSendButton button: UIButton, withText text: String) {
		layoutableView.conversationInputView.setLoading(true)
		addMessage(text, to: request)
	}

}

// MARK: - Networking
extension ConversationViewController {

	func readRequest(_ request: Ticket) {
		Desk360.apiProvider.request(.ticketWithId(request.id)) { [weak self] result in

			guard let self = self else { return }
			switch result {
			case .failure(let error):
				if error.response?.statusCode == 400 {
					Desk360.isRegister = false
					Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: false)
				print(error.localizedDescription)
			case .success(let response):
				guard let tickets = try? response.map(DataResponse<Ticket>.self) else { return }
				guard let data = tickets.data else { return }
				self.request = data

				if let url = data.attachmentUrl {
					self.attachment = url
				}

				self.layoutableView.tableView.reloadData()
				self.scrollToBottom(animated: false)
			}
			self.layoutableView.setLoading(false)
		}
	}

	func addMessage(_ message: String, to request: Ticket) {
		let id = (request.messages.last?.id ?? 0) + 1

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		self.appendMessage(message: Message(id: id, message: message, isAnswer: false, createdAt: formatter.string(from: Date())))

		Desk360.apiProvider.request(.ticketMessages(message, request.id)) { [weak self] result in
			guard let self = self else { return }
			self.layoutableView.conversationInputView.setLoading(false)
			switch result {
			case .failure(let error):
				if error.response?.statusCode == 400 {
					Desk360.isRegister = false
					Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: true)
					return
				}
				Alert.showAlertWithDismiss(viewController: self, title: "Desk360", message: "general.error.message".localize(), dissmis: false)
				print(error.localizedDescription)
			case .success(let response):
				guard let responseObject = try? response.map(DataResponse<Message>.self) else { return }
				guard let message = responseObject.data else { return }
			}
		}
	}

}

// MARK: - Helpers
private extension ConversationViewController {

	func appendMessage(message: Message) {
		layoutableView.conversationInputView.resignFirstResponder()

		request.messages.append(message)

		layoutableView.tableView.beginUpdates()
		let indexPath = IndexPath(row: request.messages.count - 1, section: 0)
		layoutableView.tableView.insertRows(at: [indexPath], with: .top)
		layoutableView.tableView.endUpdates()
		scrollToBottom(animated: true)

		try? Stores.ticketsStore.save(request)

		layoutableView.conversationInputView.reset()
	}

	func requiredInitialScrollViewBottomInset() -> CGFloat {
		guard let inputAccessoryView = inputAccessoryView else { return 0 }
		return max(0, inputAccessoryView.frame.height + additionalBottomInset - automaticallyAddedBottomInset)
	}

	var automaticallyAddedBottomInset: CGFloat {
		if #available(iOS 11.0, *) {
			return layoutableView.tableView.adjustedContentInset.bottom - layoutableView.tableView.contentInset.bottom
		} else {
			return 0
		}
	}

	func requiredScrollViewBottomInset(forKeyboardFrame keyboardFrame: CGRect) -> CGFloat {
		let intersection = layoutableView.tableView.frame.intersection(keyboardFrame)

		if intersection.isNull || intersection.maxY < layoutableView.tableView.frame.maxY {
			return max(0, additionalBottomInset - automaticallyAddedBottomInset)
		} else {
			return max(0, intersection.height + additionalBottomInset - automaticallyAddedBottomInset)
		}
	}

	func scrollToBottom(animated: Bool) {
		let row = request.messages.count - 1
		guard row >= 0 else { return }

		let lastIndexPath = IndexPath(row: row, section: 0)
		DispatchQueue.main.async {
			self.layoutableView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
		}
	}

}

// MARK: - Actions
extension ConversationViewController {

	@objc func didTapNewRequestButton() {
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: true), animated: true)
	}

	@objc func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}

}

extension ConversationViewController {

	func configure() {
		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(Config.shared.model.generalSettings?.navigationTitleFontSize ?? 16), weight: Font.weight(type: Config.shared.model.generalSettings?.navigationTitleFontWeight ?? 400)), NSAttributedString.Key.shadow: NSShadow() ]
		let navigationTitle = NSAttributedString(string: Config.shared.model.ticketDetail?.title ?? "", attributes: selectedattributes as [NSAttributedString.Key: Any])
		let titleLabel = UILabel()
		titleLabel.attributedText = navigationTitle
		titleLabel.sizeToFit()
		titleLabel.textAlignment = .center
		titleLabel.textColor = Colors.navigationTextColor
		navigationItem.titleView = titleLabel

		navigationItem.title = Config.shared.model.ticketDetail?.title
		self.navigationController?.navigationBar.setColors(background: Colors.navigationBackgroundColor, text: Colors.navigationTextColor)
		navigationController?.navigationBar.tintColor = Colors.navigationImageViewTintColor
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		layoutableView.configure()
	}

}

// MARK: - KeyboardObserving
extension ConversationViewController: KeyboardObserving {

	func keyboardWillShow(_ notification: KeyboardNotification?) {
		let height = notification?.endFrame.size.height ?? 300
		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()
		additionalBottomInset = height - layoutableView.conversationInputView.frame.size.height
	}

	func keyboardWillHide(_ notification: KeyboardNotification?) {
		additionalBottomInset = 0
		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()
	}

	func keyboardDidHide(_ notification: KeyboardNotification?) {}
	func keyboardDidShow(_ notification: KeyboardNotification?) {}
	func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {}
	func keyboardDidChangeFrame(_ notification: KeyboardNotification?) {}

}
