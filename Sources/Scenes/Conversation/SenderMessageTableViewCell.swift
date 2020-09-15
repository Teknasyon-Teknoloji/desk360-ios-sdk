//
//  SenderMessageTableViewCell.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit
import PDFKit

final class SenderMessageTableViewCell: UITableViewCell, Reusable, Layoutable {

	private lazy var containerView: UIView = {
		var view = UIView()
		view.clipsToBounds = true
		return view
	}()

	private lazy var messageTextView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.isScrollEnabled = false
		textView.allowsEditingTextAttributes = false
		textView.dataDetectorTypes = .link
		textView.font = Desk360.Config.Conversation.MessageCell.Receiver.messageFont
		textView.backgroundColor = .clear
		return textView
	}()

	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.font = Desk360.Config.Conversation.MessageCell.Sender.dateFont
		label.textAlignment = .right
		return label
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [messageTextView ])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		view.spacing = preferredSpacing * 0.5
		return view
	}()

	private var containerBackgroundColor: UIColor? {
		didSet {
			containerView.backgroundColor = containerBackgroundColor
			messageTextView .backgroundColor = containerBackgroundColor
			dateLabel.backgroundColor = containerBackgroundColor
		}
	}

	func setupViews() {
		backgroundColor = .clear
		selectionStyle = .none

		containerView.addSubview(stackView)
		addSubview(containerView)
		addSubview(dateLabel)
	}

	func setupLayout() {
		containerView.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().inset(preferredSpacing / 2)
			make.width.equalTo(UIScreen.main.bounds.size.minDimension - (preferredSpacing * 2))
		}
		stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(preferredSpacing / 2) }

		dateLabel.snp.makeConstraints { make in
			make.leading.equalTo(containerView.snp.leading).offset(preferredSpacing * 0.5)
			make.top.equalTo(containerView.snp.bottom).offset(preferredSpacing * 0.25)
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.25)
			make.height.equalTo(preferredSpacing)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		roundCorner()

	}

}

// MARK: - Configure
internal extension SenderMessageTableViewCell {

	func configure(for request: Message) {
		containerView.backgroundColor = Colors.ticketDetailChatSenderBackgroundColor
		messageTextView.text = request.message
		messageTextView.textColor = Colors.ticketDetailChatSenderTextColor
		messageTextView.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.ticketDetail?.chatSenderFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.ticketDetail?.chatSenderFontWeight ?? 400))
		dateLabel.textColor = Colors.ticketDetailChatSenderDateColor

		roundCorner()

        if let dateString = request.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.date(from: dateString) {
                let formattedDate = DateFormat.raadable.dateFormatter.string(from: date)
                dateLabel.text = formattedDate
            } else {
                dateLabel.text = dateString
            }
        }
	}

	func roundCorner() {
		let type = Config.shared.model?.ticketDetail?.chatBoxStyle

		let containerShadowIsHidden = Config.shared.model?.ticketDetail?.chatSenderShadowIsHidden ?? true

		switch type {
		case 1:
			containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 10, isShadow: !containerShadowIsHidden)
		case 2:
			containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 30, isShadow: !containerShadowIsHidden)
		case 3:
			containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 19, isShadow: !containerShadowIsHidden)
		case 4:
			containerView.layer.cornerRadius = 0
			addSubLayerChatBubble()
			containerBackgroundColor = .clear
		default:
			containerView.roundCorners([.topLeft, .bottomRight, .topRight], radius: 10, isShadow: !containerShadowIsHidden)
		}

		if containerShadowIsHidden {
			containerView.layer.shadowColor = UIColor.black.cgColor
			containerView.layer.shadowOffset = CGSize.zero
			containerView.layer.shadowRadius = 10
			containerView.layer.shadowOpacity = 0.3
			containerView.layer.masksToBounds = false
		}

	}

	func addSubLayerChatBubble() {

		stackView.snp.remakeConstraints { remake in
			remake.leading.equalToSuperview().inset(preferredSpacing)
			remake.top.trailing.bottom.equalToSuperview().inset(preferredSpacing / 2)
		}
		let width = containerView.frame.width
		let height = containerView.frame.height

		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: 0, y: height))
		bezierPath.addLine(to: CGPoint(x: width - 4, y: height))
		bezierPath.addCurve(to: CGPoint(x: width, y: height - 4), controlPoint1: CGPoint(x: width - 2, y: height), controlPoint2: CGPoint(x: width, y: height - 2))
		bezierPath.addLine(to: CGPoint(x: width, y: 4))
		bezierPath.addCurve(to: CGPoint(x: width - 4, y: 0), controlPoint1: CGPoint(x: width, y: 2), controlPoint2: CGPoint(x: width - 2, y: 0))
		bezierPath.addLine(to: CGPoint(x: 16, y: 0))
		bezierPath.addCurve(to: CGPoint(x: 12, y: 4), controlPoint1: CGPoint(x: 14, y: 0), controlPoint2: CGPoint(x: 12, y: 2))
		bezierPath.addLine(to: CGPoint(x: 12, y: height - 8))
		bezierPath.addLine(to: CGPoint(x: 4, y: height))

		let incomingMessageLayer = CAShapeLayer()
		incomingMessageLayer.path = bezierPath.cgPath
		incomingMessageLayer.frame = CGRect(x: 0,
											y: 0,
											width: width,
											height: height)
		incomingMessageLayer.fillColor = Colors.ticketDetailChatSenderBackgroundColor.cgColor

		if let layers = containerView.layer.sublayers {
			for layer in layers where layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		}

		containerView.layer.insertSublayer(incomingMessageLayer, below: stackView.layer)
		containerView.clipsToBounds = false
	}

}
