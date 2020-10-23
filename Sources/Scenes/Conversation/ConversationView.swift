//
//  ConversationView.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

/// This view is used to chat screen
final class ConversationView: UIView, Layoutable, Loadingable {

	/// Some keyboard library force main view. They change main view origin. This code protects this view from this situation. But if application has that keyboard libraries probably Desk360 has some viisual problems.
	public override var frame: CGRect {
		willSet {
			if self.frame.origin.y < 0 {
				isCustomKeyboardActive = true
			}
		}
		didSet {
			guard self.frame.origin.y < 0 else { return }
			self.frame = oldValue
		}
	}
    
	/// This parameter is used to detect third party keyboard actions.
	var isCustomKeyboardActive = false
    
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.keyboardDismissMode = .none
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

	/// This method is used to adapt to keyboard actions
	/// - Parameter bottomInset: this parameter is used to detect keyboard height
    func remakeTableViewConstraint(bottomInset: CGFloat) {
		tableView.snp.remakeConstraints { remakeConstraints in
			remakeConstraints.leading.top.trailing.equalToSuperview()
			remakeConstraints.bottom.equalToSuperview().inset(bottomInset)
		}
	}

}

// MARK: - Actions
private extension ConversationView {

	@objc func didTap() {
		conversationInputView.resignFirstResponder()
	}

}

// MARK: - Configure
extension ConversationView {

	func configure() {
		self.backgroundColor = Colors.ticketDetailChatBackgroundColor
		self.tableView.backgroundColor = Colors.ticketDetailChatBackgroundColor
	}

}
