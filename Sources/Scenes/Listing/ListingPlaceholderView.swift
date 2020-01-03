//
//  RequestListingPlaceholderView.swift
//  Desk360
//
//  Created by samet on 17.05.2019.
//

import UIKit

final class ListingPlaceholderView: UIView, Layoutable {

	internal lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 4
		label.textAlignment = .center
		label.text = Desk360.Strings.Support.listingPlaceholderLabelTitle
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	internal lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 6
		label.textAlignment = .center
		label.text = Desk360.Strings.Support.listingPlaceholderLabelTitle
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	internal lazy var createRequestButton: UIButton = {
		var button = UIButton(type: .system)
		button.layer.borderWidth = 1
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return button
	}()

	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
		view.axis = .vertical
		view.distribution = .fill
		view.alignment = .fill
		view.spacing = preferredSpacing * 1.5
		return view
	}()

	internal lazy var bottomScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.alwaysBounceVertical = true
		return scrollView
	}()

	internal lazy var bottomDescriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			titleLabel.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		addSubview(stackView)
		addSubview(createRequestButton)
		addSubview(bottomScrollView)

		bottomScrollView.addSubview(bottomDescriptionLabel)
	}

	func setupLayout() {

		createRequestButton.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
		}

		stackView.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.top.greaterThanOrEqualTo(safeArea.top).inset(preferredSpacing)
			make.bottom.lessThanOrEqualTo(createRequestButton.snp.top).inset(preferredSpacing)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(-preferredSpacing * 4)
		}

		bottomScrollView.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size))
			make.centerX.equalToSuperview()
			make.height.equalTo(preferredSpacing * 2.5)
		}

		bottomDescriptionLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.top.equalToSuperview()
			make.height.greaterThanOrEqualTo(preferredSpacing * 2.5)
		}
	}

}

// MARK: - Helpers
extension ListingPlaceholderView {

	func createButtonType1() {
		createRequestButton.layer.cornerRadius = 22
		setupButtonDefaultLayout()
	}

	func createButtonType2() {
		createRequestButton.layer.cornerRadius = 10
		setupButtonDefaultLayout()
	}

	func createButtonType3() {
		createRequestButton.layer.cornerRadius = 2
		setupButtonDefaultLayout()
	}

	func createButtonType4() {

		createRequestButton.layer.cornerRadius = 0

		createRequestButton.snp.remakeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) + 2)
			if !(Config.shared.model.firstScreen?.bottomNoteIsHidden ?? false) {
				make.bottom.equalToSuperview()
			} else {
				make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			}
			make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
		}
	}

	func setupButtonDefaultLayout() {
		createRequestButton.snp.remakeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight)
			make.centerX.equalToSuperview()
		}
	}

	func configureButton() {
		let type = Config.shared.model.firstScreen?.buttonStyleId
		createRequestButton.layer.shadowColor = UIColor.clear.cgColor
		createRequestButton.setImage(UIImage(), for: .normal)

		let imageIshidden = Config.shared.model.firstScreen?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model.firstScreen?.buttonShadowIsHidden ?? true

		switch type {
		case 1:
			createButtonType1()
		case 2:
			createButtonType2()
		case 3:
			createButtonType3()
		case 4:
			createButtonType4()
		default:
			createButtonType1()
		}

		if imageIshidden {
			createRequestButton.setImage(Desk360.Config.Images.unreadIcon, for: .normal)
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				createRequestButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
			} else {
				createRequestButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
			}
			createRequestButton.imageView?.tintColor = Colors.firstScreenButtonTextColor
		}

		if buttonShadowIsHidden {
			createRequestButton.layer.shadowColor = UIColor.black.cgColor
			createRequestButton.layer.shadowOffset = CGSize.zero
			createRequestButton.layer.shadowRadius = 10
			createRequestButton.layer.shadowOpacity = 0.3
			createRequestButton.layer.masksToBounds = false
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

// MARK: - Configuer
extension ListingPlaceholderView {

	func configure() {

		self.backgroundColor = Colors.backgroundColor

		titleLabel.text = Config.shared.model.firstScreen?.title
		titleLabel.textColor = Colors.firstScreenTitleColor
		titleLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.firstScreen?.titleFontSize ?? 18), weight: Font.weight(type: Config.shared.model.firstScreen?.titleFontWeight ?? 400))

		descriptionLabel.text = Config.shared.model.firstScreen?.description
		descriptionLabel.textColor = Colors.firstScreenDescriptionColor
		descriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.firstScreen?.descriptionFontSize ?? 16), weight: Font.weight(type: Config.shared.model.firstScreen?.descriptionFontWeight ?? 400))

		createRequestButton.backgroundColor = Colors.firstScreenButtonBackgroundColor
		createRequestButton.layer.borderColor = Colors.firstScreenButttonBorderColor.cgColor
		createRequestButton.setTitleColor(Colors.firstScreenButtonTextColor, for: .normal)
		createRequestButton.imageView?.tintColor = Colors.firstScreenButtonTextColor
		createRequestButton.tintColor = Colors.firstScreenButtonTextColor
		createRequestButton.setTitle(Config.shared.model.firstScreen?.buttonText, for: .normal)
		createRequestButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.firstScreen?.buttonTextFontSize ?? 14), weight: Font.weight(type: Config.shared.model.firstScreen?.buttonTextFontWeight ?? 400))

		bottomDescriptionLabel.text = Config.shared.model.firstScreen?.bottomNoteText
		bottomDescriptionLabel.sizeToFit()
		bottomScrollView.isHidden = !(Config.shared.model.firstScreen?.bottomNoteIsHidden ?? false)
		bottomDescriptionLabel.textColor = Colors.bottomNoteColor
		bottomDescriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.generalSettings?.bottomNoteFontSize ?? 8), weight: Font.weight(type: Config.shared.model.generalSettings?.bottomNoteFontWeight ?? 400))
		bottomScrollView.isUserInteractionEnabled = Config.shared.model.firstScreen?.bottomNoteIsHidden ?? false

		configureButton()

	}

}
