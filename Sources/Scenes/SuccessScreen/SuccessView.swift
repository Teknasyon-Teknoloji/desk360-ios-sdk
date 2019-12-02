//
//  SuccessView.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

final class SuccessView: UIView, Layoutable {

	internal lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleToFill
		view.image = Desk360.Config.Images.successIcon
		view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		return view
	}()

	internal lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.setContentCompressionResistancePriority(.required, for: .horizontal)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	internal lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.setContentCompressionResistancePriority(.required, for: .horizontal)
		label.numberOfLines = 4
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	internal lazy var showListButton: UIButton = {
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

	private lazy var desk360BottomView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.init(hex: "71717b")!
		view.addSubview(self.desk360Label)
		view.addSubview(self.poweredByLabel)
		return view
	}()

	private lazy var desk360Label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.text = " DESK360 "
		label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
		label.textAlignment = .right
		return label
	}()

	private lazy var poweredByLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.text = "powered by"
		label.font = UIFont.systemFont(ofSize: 12)
		label.textAlignment = .right
		return label
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			titleLabel.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		addSubview(imageView)
		addSubview(stackView)
		addSubview(showListButton)
		addSubview(bottomScrollView)
		addSubview(desk360BottomView)
		bottomScrollView.addSubview(bottomDescriptionLabel)
	}

	func setupLayout() {

		imageView.snp.makeConstraints { make in
			make.width.height.equalTo(84)
			make.centerX.equalToSuperview()
			make.top.greaterThanOrEqualTo(safeArea.top).inset(preferredSpacing)
		}

		showListButton.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 1.25)
			make.centerX.equalToSuperview()
		}

		titleLabel.snp.makeConstraints { make in
			make.height.greaterThanOrEqualTo(preferredSpacing * 3)
		}

		descriptionLabel.snp.makeConstraints { make in
			make.height.greaterThanOrEqualTo(preferredSpacing * 3)
		}

		stackView.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.top.equalTo(imageView.snp.bottom).offset(preferredSpacing)
			make.bottom.lessThanOrEqualTo(showListButton.snp.top).inset(preferredSpacing)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(-preferredSpacing * 4)

		}

		bottomScrollView.snp.makeConstraints { make in
			make.bottom.equalTo(desk360BottomView.snp.top).offset(-preferredSpacing * 0.5)
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

		desk360BottomView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(preferredSpacing * 1.5)
			make.bottom.equalTo(safeArea.bottom)
		}

		desk360Label.snp.makeConstraints { make in
			make.bottom.top.equalToSuperview()
			make.right.equalToSuperview().inset(preferredSpacing * 0.5)
		}

		poweredByLabel.snp.makeConstraints { make in
			make.bottom.top.equalToSuperview()
			make.right.equalTo(desk360Label.snp.left)
		}
	}

}

// MARK: - Helpers
extension SuccessView {

	func showListButtonType1() {
		showListButton.layer.cornerRadius = 22
		setupButtonDefaultLayout()
	}

	func showListButtonType2() {
		showListButton.layer.cornerRadius = 10
		setupButtonDefaultLayout()
	}

	func showListButtonType3() {
		showListButton.layer.cornerRadius = 2
	}

	func showListButtonType4() {
		showListButton.layer.cornerRadius = 0

		showListButton.snp.remakeConstraints { remake in
			remake.width.equalTo(minDimension(size: UIScreen.main.bounds.size) + 2)
			remake.height.equalTo(UIButton.preferredHeight * 1.25)
			remake.centerX.equalToSuperview()
			if !(Config.shared.model.successScreen?.bottomNoteIsHidden ?? false) {
				remake.bottom.equalTo(desk360BottomView.snp.top)
			} else {
				remake.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			}
		}
	}

	func setupButtonDefaultLayout() {
		showListButton.snp.remakeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 1.25)
			make.centerX.equalToSuperview()
		}
	}

}

extension SuccessView {

	func configure() {

		self.backgroundColor = Colors.backgroundColor
		titleLabel.text = Config.shared.model.successScreen?.title
		titleLabel.textColor = Colors.ticketSuccessScreenTitleColor
		titleLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.successScreen?.titleFontSize ?? 18), weight: Font.weight(type: Config.shared.model.successScreen?.titleFontWeight ?? 400))

		descriptionLabel.text = Config.shared.model.successScreen?.description
		descriptionLabel.textColor = Colors.ticketSuccessScreenDescriptionColor
		descriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.successScreen?.descriptionFontSize ?? 14), weight: Font.weight(type: Config.shared.model.successScreen?.descriptionFontWeight ?? 400))

		showListButton.backgroundColor = Colors.ticketSuccessScreenButtonBackgroundColor
		showListButton.setTitleColor(Colors.ticketSuccessScreenButtonTextColor, for: .normal)
		showListButton.imageView?.tintColor = Colors.ticketSuccessScreenButtonTextColor
		showListButton.tintColor = Colors.ticketSuccessScreenButtonTextColor
		showListButton.layer.borderColor = Colors.ticketSuccessScreenButttonBorderColor.cgColor
		showListButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.successScreen?.buttonTextFontSize ?? 14), weight: Font.weight(type: Config.shared.model.successScreen?.buttonTextFontWeight ?? 400))
		showListButton.setTitle(Config.shared.model.successScreen?.buttonText, for: .normal)

		imageView.tintColor = Colors.ticketSuccessScreenIconColor

		bottomDescriptionLabel.text = Config.shared.model.successScreen?.bottomNoteText
		bottomScrollView.isHidden = !(Config.shared.model.successScreen?.bottomNoteIsHidden ?? false)
		bottomDescriptionLabel.textColor = Colors.bottomNoteColor
		bottomDescriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model.generalSettings?.bottomNoteFontSize ?? 8), weight: Font.weight(type: Config.shared.model.generalSettings?.bottomNoteFontWeight ?? 400))
		bottomDescriptionLabel.sizeToFit()
		bottomScrollView.isUserInteractionEnabled = Config.shared.model.successScreen?.bottomNoteIsHidden ?? false

		configureButton()

		let size = Config.shared.model.successScreen?.iconSize ?? 100
		imageView.snp.remakeConstraints { remake in
			remake.width.height.equalTo(CGFloat(size))
			remake.centerX.equalToSuperview()
			remake.top.greaterThanOrEqualTo(safeArea.top).inset(preferredSpacing)
		}

		titleLabel.snp.remakeConstraints { remake in
			remake.height.greaterThanOrEqualTo(preferredSpacing * 3)
		}
		descriptionLabel.snp.remakeConstraints { remake in
			remake.height.greaterThanOrEqualTo(preferredSpacing * 3)
		}

		titleLabel.sizeToFit()
		descriptionLabel.sizeToFit()

	}

	func configureButton() {
		let type = Config.shared.model.successScreen?.buttonStyleId

		showListButton.layer.shadowColor = UIColor.clear.cgColor
		showListButton.setImage(UIImage(), for: .normal)
		let imageIshidden = Config.shared.model.successScreen?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model.successScreen?.buttonShadowIsHidden ?? true

		switch type {
		case 1:
			showListButtonType1()
		case 2:
			showListButtonType2()
		case 3:
			showListButtonType3()
		case 4:
			showListButtonType4()
		default:
			showListButtonType1()
		}

		if imageIshidden {
			showListButton.setImage(Desk360.Config.Images.unreadIcon, for: .normal)
			if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
				showListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
			} else {
				showListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
			}
			showListButton.imageView?.tintColor = Colors.ticketSuccessScreenButtonTextColor
		}

		if buttonShadowIsHidden {
			showListButton.layer.shadowColor = UIColor.black.cgColor
			showListButton.layer.shadowOffset = CGSize.zero
			showListButton.layer.shadowRadius = 10
			showListButton.layer.shadowOpacity = 0.3
			showListButton.layer.masksToBounds = false
		}

	}

}

// MARK: - Helpers
extension SuccessView {

	/// Returns width or height, whichever is the smaller value.
	func minDimension(size: CGSize) -> CGFloat {
		return min(size.width, size.height)
	}

}
