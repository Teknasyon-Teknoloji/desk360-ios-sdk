//
//  ConversationViewController.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

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

	override var inputAccessoryView: UIView? {
		let view = layoutableView.conversationInputView
		view.delegate = self
		view.configure(for: request)
		return view
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}

	/// This parameter is used to ticket media objects
	var attachment: URL?

	/// This parameter is used to fix to problems created by the custom keyboard
	var previousLineCount = 0
	var currentLineCount = 0

	var safeAreaBottom: CGFloat = {
		if #available(iOS 11.0, *) {
			return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
		} else {
			return 0
		}
	}()

	var safeAreaTop: CGFloat = {
		if #available(iOS 11.0, *) {
			return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
		} else {
			return 0
		}
	}()

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

		layoutableView.conversationInputView.createRequestButton.addTarget(self, action: #selector(didTapNewRequestButton), for: .touchUpInside)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		previousLineCount = 0
		currentLineCount = 0

		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()

		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.interactivePopGestureRecognizer?.delegate  = self
		navigationItem.leftBarButtonItem = NavigationItems.back(target: self, action: #selector(didTapBackButton))

		configure()

		layoutableView.remakeTableViewConstraint(bottomInset: layoutableView.conversationInputView.frame.size.height)

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		layoutableView.setLoading(true)
		readRequest(request)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		layoutableView.conversationInputView.textView.resignFirstResponder()
		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()
	}

	@objc
	private func handleKeyboardDidChangeState(_ notification: Notification) {


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
	}

	func inputView(_ view: InputView, didTapSendButton button: UIButton, withText text: String) {
		layoutableView.conversationInputView.setLoading(true)
		addMessage(text, to: request)
	}

}

// MARK: - Networking
extension ConversationViewController {

	/// This method use is to get one ticket from the use id
	/// - Parameter request: this parameter is a ticket object we will use its id and we will use its properties
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

	/// This method is used to send a request to backend for add a message in ticket
	/// - Parameters:
	///   - message: this parameter is a user message
	///   - request: this parameter is a ticket object
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
			case .success:
				print("Add ticket new message")
			}
		}
	}

}

// MARK: - Helpers
private extension ConversationViewController {

	/// This method is used to  a add a message in ticket
	/// - Parameter message: this parameter is a user message
	func appendMessage(message: Message) {
		layoutableView.conversationInputView.resignFirstResponder()

		request.messages.append(message)

		layoutableView.tableView.beginUpdates()
		let indexPath = IndexPath(row: request.messages.count - 1, section: 0)
		layoutableView.tableView.insertRows(at: [indexPath], with: .top)
		layoutableView.tableView.endUpdates()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.scrollToBottom(animated: true)
		}

		try? Stores.ticketsStore.save(request)

		layoutableView.conversationInputView.reset()
	}

	/// This method is used to scroll to tableview bottom
	/// - Parameter animated:this parameter is used  to scroll animation
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

	/// This method is used to direction to create request screen
	@objc func didTapNewRequestButton() {
		navigationController?.pushViewController(CreateRequestViewController(checkLastClass: true), animated: true)
	}

	/// This method is used to pop action on navigationcontroller
	@objc func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}

}

// MARK: - Configure
extension ConversationViewController {

	func configure() {
		let fontWeight = Font.weight(type: Config.shared.model.generalSettings?.navigationTitleFontWeight ?? 400)
		let fontSize = CGFloat(Config.shared.model.generalSettings?.navigationTitleFontSize ?? 16)
		let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: font, NSAttributedString.Key.shadow: NSShadow() ]
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

	func keyboardWillShow(_ notification: KeyboardNotification?) { }

	func keyboardWillHide(_ notification: KeyboardNotification?) {

		layoutableView.remakeTableViewConstraint(bottomInset: layoutableView.conversationInputView.frame.size.height)
		scrollToBottom(animated: true)

		layoutableView.conversationInputView.layoutIfNeeded()
		layoutableView.conversationInputView.layoutSubviews()
	}

	func keyboardDidHide(_ notification: KeyboardNotification?) {}
	func keyboardDidShow(_ notification: KeyboardNotification?) {}
	func keyboardWillChangeFrame(_ notification: KeyboardNotification?) {

		guard let keyboardEndFrame = notification?.endFrame else { return }

		currentLineCount = Int(layoutableView.conversationInputView.textView.frame.height / (layoutableView.conversationInputView.textView.font?.lineHeight ?? 1))

		var safeArea: CGFloat = 0

		if layoutableView.isCustomKeyboardActive {
			safeArea = safeAreaBottom
		}

		layoutableView.remakeTableViewConstraint(bottomInset: keyboardEndFrame.size.height - safeArea)
		scrollToBottom(animated: true)
	}
	func keyboardDidChangeFrame(_ notification: KeyboardNotification?) {}

}
