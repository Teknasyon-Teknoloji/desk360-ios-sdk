//
//  ConversationViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import Result

final class ConversationViewController: UIViewController, Layouting, UITableViewDataSource, UITableViewDelegate {

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

	func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		scrollToBottom(animated: true)
		return false
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if request.status == .expired {
			view.backgroundColor = Desk360.Config.Conversation.Input.CreateRequestButton.backgroundColor
		}

		layoutableView.tableView.dataSource = self
		layoutableView.tableView.delegate = self
		layoutableView.conversationInputView.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = request.subject
//			Desk360.Config.Conversation.title ?? request.message.ars.truncate(toLength: 15)
		scrollToBottom(animated: false)

		if let icon = Desk360.Config.Conversation.backBarButtonIcon {
			navigationController?.navigationBar.backIndicatorImage = icon
			navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
			navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
		}
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
		cell.configure(for: request.messages[indexPath.row])
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
			self.layoutableView.setLoading(false)
			switch result {
			case .failure(let response):
				print(response.localizedDescription)

			case .success(let response):
				guard let tickets = try? response.map(DataResponse<[Ticket]>.self) else { return }
				guard let data = tickets.data else { return }
				guard data.count > 0 else { return }
				self.request = data[0]
				self.layoutableView.tableView.reloadData()
			}
		}
	}

	func addMessage(_ message: String, to request: Ticket) {

		Desk360.apiProvider.request(.ticketMessages(message, request.id)) { [weak self] result in
			guard let self = self else { return }
			self.layoutableView.conversationInputView.setLoading(false)
			switch result {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let response):
				guard let message = try? response.map(DataResponse<NewMessage>.self) else { return }
				self.appendMessage(message: String(message.data?.message ?? ""))
//				self.layoutableView.tableView.reloadData()
			}
		}
	}

}

// MARK: - Helpers
private extension ConversationViewController {

	func appendMessage(message: String?) {
		layoutableView.conversationInputView.resignFirstResponder()

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let random = Int.random(in: 0 ... 10)
		let newMessage = Message(id: random, message: message ?? "", isAnswer: false, createdAt: formatter.string(from: Date()))

		request.messages.append(newMessage)

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
