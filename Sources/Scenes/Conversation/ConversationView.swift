//
//  ConversationView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

final class ConversationView: UIView, Layoutable, Loadingable {

	lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.keyboardDismissMode = .interactive
		view.showsVerticalScrollIndicator = false
		view.contentInset = UIEdgeInsets.init(top: preferredSpacing, left: 0, bottom: preferredSpacing, right: 0)

		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 200.0

		return view
	}()

	lazy var conversationInputView: InputView = {
		return InputView.create()
	}()

	func setupViews() {
		tableView.backgroundColor = Desk360.Config.Conversation.backgroundColor
		backgroundColor = Desk360.Config.Conversation.Input.backgroundColor
		addSubview(tableView)

		let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
		addGestureRecognizer(tap)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(safeArea.bottom)
		}
	}

}

// MARK: - Actions
private extension ConversationView {

	@objc
	func didTap() {
		conversationInputView.resignFirstResponder()
	}

}
