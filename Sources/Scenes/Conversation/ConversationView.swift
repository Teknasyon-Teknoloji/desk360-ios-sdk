//
//  ConversationView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

/// This view is used to chat screen
final class ConversationView: UIView, Layoutable, Loadingable {

	/// This parameter is used to detect third party keyboard actions.
	var isCustomKeyboardActive = false

	lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.keyboardDismissMode = .onDrag
		view.showsVerticalScrollIndicator = false
//		view.contentInset = UIEdgeInsets.init(top: preferredSpacing, left: 0, bottom: preferredSpacing, right: 0)

		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 200.0
		return view
	}()

//	lazy var conversationInputView: InputView = {
//        return InputView(frame: .init(origin: .zero, size: .init(width: frame.width, height: 96)))
//	}()

	func setupViews() {
		addSubview(tableView)

		let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
		addGestureRecognizer(tap)
	}

	func setupLayout() {

		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}

}

// MARK: - Actions
private extension ConversationView {

	@objc func didTap() {
		// conversationInputView.resignFirstResponder()
	}

}

// MARK: - Configure
extension ConversationView {

	func configure() {
		self.backgroundColor = Colors.ticketDetailChatBackgroundColor
		self.tableView.backgroundColor = Colors.ticketDetailChatBackgroundColor
	}

}
