//
//  SenderMessageTableViewCell.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

final class SenderMessageTableViewCell: UITableViewCell, Reusable, Layoutable {

	private lazy var containerView: UIView = {
		var view = UIView()
		view.backgroundColor = Desk360.Config.currentTheme.senderCellBackgroundColor
		view.clipsToBounds = true
		return view
	}()

	private lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = Desk360.Config.currentTheme.senderCellMessageTextColor
		label.font = Desk360.Config.Conversation.MessageCell.Sender.messageFont
		return label
	}()

	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.currentTheme.senderCellDateTextColor
		label.font = Desk360.Config.Conversation.MessageCell.Sender.dateFont
		label.textAlignment = .right
		return label
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [messageLabel, dateLabel])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		view.spacing = preferredSpacing * 0.5
		return view
	}()

	private var containerBackgroundColor: UIColor? {
		didSet {
			containerView.backgroundColor = containerBackgroundColor
			messageLabel.backgroundColor = containerBackgroundColor
			dateLabel.backgroundColor = containerBackgroundColor
		}
	}

	func setupViews() {
		backgroundColor = .clear
		selectionStyle = .none

		containerView.addSubview(stackView)
		addSubview(containerView)
	}

	func setupLayout() {
		containerView.snp.makeConstraints { make in
			make.top.leading.bottom.equalToSuperview().inset(preferredSpacing / 2)
			make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
		}
		stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(preferredSpacing / 2) }
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		containerView.roundCorners([.bottomRight, .topLeft, .topRight], radius: Desk360.Config.Conversation.MessageCell.Sender.cornerRadius)
	}

}

// MARK: - Configure
internal extension SenderMessageTableViewCell {

	func configure(for request: Message) {
		messageLabel.text = request.message

		if let dateString = request.createdAt {
			dateLabel.text = dateString
		}
	}

}
