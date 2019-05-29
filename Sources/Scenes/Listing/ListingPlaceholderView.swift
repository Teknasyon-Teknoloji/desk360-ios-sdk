//
//  RequestListingPlaceholderView.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import UIKit

final class ListingPlaceholderView: UIView, Layoutable {

	internal lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.tintColor = Desk360.Config.Requests.Listing.Placeholder.tintColor
		view.image = Desk360.Config.Requests.Listing.Placeholder.image
		view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		return view
	}()

	internal lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = Desk360.Config.Requests.Listing.Placeholder.Title.font
		label.textColor = Desk360.Config.Requests.Listing.Placeholder.Title.textColor
		label.text = Desk360.Strings.Support.listingPlaceholderLabelTitle
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	internal lazy var createRequestButton: UIButton = {
		var button = UIButton(type: .system)
		button.backgroundColor = Desk360.Config.Requests.Listing.Placeholder.CreateButton.backgroundColor
		button.setTitle(Desk360.Strings.Support.listingPlaceholderButtonTitle, for: .normal)
		button.titleLabel?.textColor =  Desk360.Config.Requests.Listing.Placeholder.CreateButton.titleColor
		button.tintColor = Desk360.Config.Requests.Listing.Placeholder.CreateButton.titleColor
		button.layer.borderWidth = Desk360.Config.Requests.Listing.Placeholder.CreateButton.borderWidth
		button.layer.cornerRadius = Desk360.Config.Requests.Listing.Placeholder.CreateButton.cornerRadius
		button.layer.borderColor = Desk360.Config.Requests.Listing.Placeholder.CreateButton.borderColor?.cgColor
		button.clipsToBounds = true
		button.titleLabel?.font = Desk360.Config.Requests.Listing.Placeholder.CreateButton.font
		button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return button
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [imageView, titleLabel, createRequestButton])
		view.axis = .vertical
		view.distribution = .fill
		view.alignment = .fill
		view.spacing = preferredSpacing * 1.5
		return view
	}()

	private lazy var desk360Label: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.Requests.Listing.Placeholder.desk360LabelTextColor
		label.text = "Desk360"
		label.font = UIFont.systemFont(ofSize: 12)
		label.textAlignment = .center
		return label
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			imageView.backgroundColor = backgroundColor
			titleLabel.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		backgroundColor = Desk360.Config.Requests.Listing.Placeholder.backgroundColor
		addSubview(stackView)
		addSubview(desk360Label)
	}

	func setupLayout() {
		imageView.snp.makeConstraints { make in
			make.height.lessThanOrEqualTo(preferredSpacing * 10)
			make.height.greaterThanOrEqualTo(preferredSpacing * 3)
		}

		createRequestButton.snp.makeConstraints { $0.height.equalTo(UIButton.preferredHeight) }

		stackView.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.top.greaterThanOrEqualTo(safeArea.top).inset(preferredSpacing)
			make.bottom.lessThanOrEqualTo(safeArea.bottom).inset(preferredSpacing)
			make.center.equalToSuperview()
		}

		desk360Label.snp.makeConstraints { make in
			make.bottom.leading.trailing.equalToSuperview().inset(preferredSpacing * 0.5)
		}

	}

}

// MARK: - Helpers
extension ListingPlaceholderView {

	/// Returns width or height, whichever is the smaller value.
	func minDimension(size: CGSize) -> CGFloat {
		return min(size.width, size.height)
	}

}
