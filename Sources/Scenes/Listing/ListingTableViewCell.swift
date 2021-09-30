//
//  ListingTableViewCell.swift
//  Desk360
//
//  Created by samet on 16.05.2019.
//

import UIKit
import DeviceKit

final class ListingTableViewCell: UITableViewCell, Reusable, Layoutable {

	private lazy var containerView: UIView = {
		var view = UIView()
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		return view
	}()

	private lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.adjustsFontSizeToFitWidth = false
		return label
	}()

	private lazy var iconImageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		return view
	}()

	private lazy var dateLabel: UILabel = {
		return UILabel()
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [messageLabel, dateLabel])
		view.axis = .vertical
		view.alignment = .fill
		view.distribution = .fill
		return view
	}()

	private var containerBackgroundColor: UIColor? {
		didSet {
			containerView.backgroundColor = containerBackgroundColor
			messageLabel.backgroundColor = containerBackgroundColor
			iconImageView.backgroundColor = containerBackgroundColor
			dateLabel.backgroundColor = containerBackgroundColor
		}
	}

	func setupViews() {
		selectionStyle = .none
		containerView.addSubview(stackView)
		containerView.addSubview(iconImageView)
		addSubview(containerView)
	}

	func setupLayout() {
		containerView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 2)
			make.top.equalToSuperview()
		}

		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().inset(preferredSpacing / 2)
            let inset = Device.current.isPad ? preferredSpacing / 2 : preferredSpacing / 1.3
            make.top.bottom.equalToSuperview().inset(inset)
		}

		iconImageView.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.width.height.equalTo(preferredSpacing)
			make.leading.equalTo(stackView.snp.trailing).offset(preferredSpacing)
			make.trailing.equalToSuperview().inset(preferredSpacing)
		}
	}
}

// MARK: - Configure
internal extension ListingTableViewCell {

	func createContainerType1() {
		containerView.layer.cornerRadius = 10
		remakeContainerLayout()
	}

	func createContainerType2() {
		containerView.layer.cornerRadius = 4
		remakeContainerLayout()
	}

	func createContainerType3() {
		containerView.layer.cornerRadius = 2
		remakeContainerLayout()
	}

	func createContainerType4() {
		containerView.layer.cornerRadius = 0
		containerView.snp.remakeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.height.equalTo(UIButton.preferredHeight * 2)
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
		}
	}

	func remakeContainerLayout() {
		containerView.snp.remakeConstraints { make in
			make.leading.trailing.top.equalToSuperview().inset(preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 2)
			make.bottom.equalToSuperview().inset(preferredSpacing * 0.25)
		}
	}

	func setupContainerDefaultLayout() {
		containerView.snp.remakeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 2)
			make.top.equalToSuperview()
		}
	}

	func configureContainer() {
		let type = Config.shared.model?.ticketListingScreen?.ticketListType
		let shadowIsHidden = !(Config.shared.model?.ticketListingScreen?.ticketItemShadowIsHidden ?? false)

		switch type {
		case 1:
			createContainerType1()
		case 2:
			createContainerType2()
		case 3:
			createContainerType3()
		case 4:
			createContainerType4()
		default:
			createContainerType1()
		}

		containerView.layer.shadowColor = UIColor.clear.cgColor

		guard !shadowIsHidden else { return }
		containerView.layer.shadowColor = UIColor.black.cgColor
		containerView.layer.shadowOffset = CGSize.zero
		containerView.layer.shadowRadius = 10
		containerView.layer.shadowOpacity = 0.3
		containerView.clipsToBounds = false
	}
	// swiftlint:disable function_body_length
	func configure(for request: Ticket) {

		self.backgroundColor = Colors.ticketListingScreenBackgroudColor
		configureContainer()
		messageLabel.text = request.message
		dateLabel.text = DateFormat.raadable.dateFormatter.string(from: request.createdAt)

		let messageFontSize = CGFloat(Config.shared.model?.ticketListingScreen?.ticketSubjectFontSize ?? 16)
		let dateFontSize = CGFloat(Config.shared.model?.ticketListingScreen?.ticketDateFontSize ?? 11)
		let iconColor = Colors.ticketListingScreenTicketItemIconColor
		switch request.status {
		case .expired:
			containerBackgroundColor = Colors.ticketListingScreenItemBackgroudColor
			messageLabel.textColor = Colors.ticketListingScreenTicketSubjectColor
			messageLabel.font = UIFont.systemFont(ofSize: messageFontSize, weight: .regular)
			dateLabel.textColor = Colors.ticketListingScreenTicketDateColor
			dateLabel.font =  UIFont.systemFont(ofSize: dateFontSize, weight: .regular)
			iconImageView.image = nil
			iconImageView.tintColor = iconColor
			if #available(iOS 13.0, *) {
				iconImageView.image?.withTintColor(iconColor)
			}

		case .open:
			containerBackgroundColor = Colors.ticketListingScreenItemBackgroudColor
			messageLabel.textColor = Colors.ticketListingScreenTicketSubjectColor
			messageLabel.font = UIFont.systemFont(ofSize: messageFontSize, weight: .regular)
			dateLabel.textColor = Colors.ticketListingScreenTicketDateColor
			dateLabel.font = UIFont.systemFont(ofSize: dateFontSize, weight: .regular)
			iconImageView.image = nil
			iconImageView.tintColor = iconColor
			if #available(iOS 13.0, *) {
				iconImageView.image?.withTintColor(iconColor)
			}

		case .read:
			containerBackgroundColor = Colors.ticketListingScreenItemBackgroudColor
			messageLabel.textColor = Colors.ticketListingScreenTicketSubjectColor
			messageLabel.font = UIFont.systemFont(ofSize: messageFontSize, weight: .regular)
			dateLabel.textColor = Colors.ticketListingScreenTicketDateColor
			dateLabel.font = UIFont.systemFont(ofSize: dateFontSize, weight: .regular)
			iconImageView.image = Desk360.Config.Images.readIcon
			iconImageView.tintColor = iconColor
			iconImageView.tintAdjustmentMode = .automatic
			if #available(iOS 13.0, *) {
				iconImageView.image?.withTintColor(iconColor)
			}
			iconImageView.setNeedsLayout()

		case .unread:
			containerBackgroundColor = Colors.ticketListingScreenItemBackgroudColor
			messageLabel.textColor = Colors.ticketListingScreenTicketSubjectColor
			messageLabel.font = UIFont.systemFont(ofSize: messageFontSize, weight: .bold)
			dateLabel.textColor = Colors.ticketListingScreenTicketDateColor
			dateLabel.font = UIFont.systemFont(ofSize: dateFontSize, weight: .bold)
			iconImageView.image = Desk360.Config.Images.unreadIcon
			iconImageView.tintAdjustmentMode = .automatic

			iconImageView.tintColor = iconColor
			if #available(iOS 13.0, *) {
				iconImageView.image?.withTintColor(iconColor)
			}
			iconImageView.setNeedsLayout()
		}
	}
}
