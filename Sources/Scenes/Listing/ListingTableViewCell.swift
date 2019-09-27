//
//  ListingTableViewCell.swift
//  Desk360
//
//  Created by samet on 16.05.2019.
//

import UIKit

final class ListingTableViewCell: UITableViewCell, Reusable, Layoutable {

	private lazy var containerView: UIView = {
		var view = UIView()
		view.backgroundColor = Desk360.Config.currentTheme.listingCellBackgroundColor
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
		view.tintColor = Desk360.Config.currentTheme.listingCellTintColor
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
		view.spacing = preferredSpacing * 0.25
		return view
	}()

	private lazy var lineView: UIView = {
		let view = UIView()
		view.backgroundColor = Desk360.Config.currentTheme.listingCellLineColor
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
		backgroundColor = Desk360.Config.currentTheme.backgroundColor
		selectionStyle = .none

		containerView.addSubview(stackView)
		containerView.addSubview(iconImageView)
		containerView.addSubview(lineView)
		addSubview(containerView)
	}

	func setupLayout() {
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.leading.trailing.equalToSuperview()
		}

		lineView.snp.makeConstraints { make in
			make.bottom.leading.trailing.equalToSuperview()
			make.height.equalTo(2)
		}

		stackView.snp.makeConstraints { $0.leading.top.bottom.equalToSuperview().inset(preferredSpacing / 2) }

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

	func configure(for request: Ticket) {
		messageLabel.text = request.message
		dateLabel.text = DateFormat.raadable.dateFormatter.string(from: request.createdAt)

		let Config = Desk360.Config.Requests.Listing.Cell.self

		switch request.status {
		case .expired:
			containerBackgroundColor = Desk360.Config.currentTheme.listingCellBackgroundColor
			messageLabel.textColor = Desk360.Config.currentTheme.listingCellTitleColor
			messageLabel.font = Config.Expired.titleFont
			dateLabel.textColor = Desk360.Config.currentTheme.listingCellDateTextColor
			dateLabel.font = Config.Expired.dateFont
			iconImageView.image = nil
			iconImageView.tintColor = Desk360.Config.currentTheme.listingCellImageViewTintColor

		case .open:
			containerBackgroundColor = Desk360.Config.currentTheme.listingCellBackgroundColor
			messageLabel.textColor = Desk360.Config.currentTheme.listingCellTitleColor
			messageLabel.font = Config.Open.titleFont
			dateLabel.textColor = Desk360.Config.currentTheme.listingCellDateTextColor
			dateLabel.font = Config.Open.dateFont
			iconImageView.image = nil
			iconImageView.tintColor = Desk360.Config.currentTheme.listingCellImageViewTintColor

		case .read:
			containerBackgroundColor = Desk360.Config.currentTheme.listingCellBackgroundColor
			messageLabel.textColor = Desk360.Config.currentTheme.listingCellTitleColor
			messageLabel.font = Config.Read.titleFont
			dateLabel.textColor = Desk360.Config.currentTheme.listingCellDateTextColor
			dateLabel.font = Config.Read.dateFont
			iconImageView.image = Config.Read.icon
			iconImageView.tintColor = Desk360.Config.currentTheme.listingCellImageViewTintColor

		case .unread:
			containerBackgroundColor = Desk360.Config.currentTheme.listingCellBackgroundColor
			messageLabel.textColor = Desk360.Config.currentTheme.listingCellTitleColor
			messageLabel.font = Config.Unread.titleFont
			dateLabel.textColor = Desk360.Config.currentTheme.listingCellDateTextColor
			dateLabel.font = Config.Unread.dateFont
			iconImageView.image = Config.Unread.icon
			iconImageView.tintColor = Desk360.Config.currentTheme.listingCellImageViewTintColor
		}

	}

}
