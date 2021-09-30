//
//  CreatRequestPreView.swift
//  Desk360
//
//  Created by samet on 28.10.2019.
//

import UIKit

/// `CreatRequestPreView`
final class CreatRequestPreView: UIView, Layoutable {
	
	/// Title Label
	internal lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 3
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()
	
	/// Description Label
	internal lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 5
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()
	
	/// Create Request Button
	internal lazy var createRequestButton: UIButton = {
		var button = UIButton(type: .system)
		button.layer.borderWidth = 1
		button.clipsToBounds = true
		button.layer.masksToBounds = true
		button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return button
	}()
	
	/// Stack View for labels
	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
		view.axis = .vertical
		view.distribution = .fill
		view.alignment = .fill
		view.spacing = preferredSpacing * 1.5
		return view
	}()
	
	/// Scroll View
	internal lazy var bottomScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.alwaysBounceVertical = true

		return scrollView
	}()
	
	/// Desk360View bottomDescriptionLabel
	internal lazy var bottomDescriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()
	
	/// Desk360 View for bottom.
	private lazy var desk360BottomView: Desk360View = {
		return Desk360View.create()
	}()
	
	/// Override this method to set your custom views here
	public override var backgroundColor: UIColor? {
		didSet {
			titleLabel.backgroundColor = backgroundColor
		}
	}
	
	/// Override this method to set your custom layout here
	func setupViews() {
		addSubview(stackView)
		addSubview(createRequestButton)
		addSubview(bottomScrollView)
		addSubview(desk360BottomView)
		bottomScrollView.addSubview(bottomDescriptionLabel)
	}
	
	/// Create button type 4
	func setupLayout() {

		createRequestButton.snp.makeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 1.25)
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
			make.bottom.equalTo(desk360BottomView.snp.top)
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

	}

}

// MARK: - Helpers
extension CreatRequestPreView {
	
	/// Create button type 1
	func createButtonType1() {
		createRequestButton.layer.cornerRadius = 22
		setupButtonDefaultLayout()
	}
	
	/// Create button type 2
	func createButtonType2() {
		createRequestButton.layer.cornerRadius = 10
		setupButtonDefaultLayout()
	}
	
	/// Create button type 3
	func createButtonType3() {
		createRequestButton.layer.cornerRadius = 2
		setupButtonDefaultLayout()
	}
	
	/// Create button type 4
	func createButtonType4() {

		createRequestButton.layer.cornerRadius = 0

		createRequestButton.snp.remakeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) + 2)
			if !(Config.shared.model?.createPreScreen?.bottomNoteIsHidden ?? false) {
				make.bottom.equalTo(desk360BottomView.snp.top)
			} else {
				make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			}
			make.height.equalTo(UIButton.preferredHeight * 1.25)
			make.centerX.equalToSuperview()
		}
	}
	
	/// Setup for create request preview button
	func setupButtonDefaultLayout() {
		createRequestButton.snp.remakeConstraints { make in
			make.width.equalTo(minDimension(size: UIScreen.main.bounds.size) - (preferredSpacing * 3))
			make.bottom.equalTo(bottomScrollView.snp.top).offset(-preferredSpacing * 0.5)
			make.height.equalTo(UIButton.preferredHeight * 1.25)
			make.centerX.equalToSuperview()
		}
	}

}

// MARK: - Configure
extension CreatRequestPreView {
	
	/// Configure for create request preview
	func configure() {
		self.backgroundColor = Colors.backgroundColor
		titleLabel.text = Config.shared.model?.createPreScreen?.title
		titleLabel.textColor = Colors.createPreScreenTitleColor
		titleLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createPreScreen?.titleFontSize ?? 18), weight: Font.weight(type: Config.shared.model?.createPreScreen?.titleFontWeight ?? 400))

		descriptionLabel.text = Config.shared.model?.createPreScreen?.description
		descriptionLabel.textColor = Colors.createPreScreenDescriptionColor
		descriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createPreScreen?.descriptionFontSize ?? 14), weight: Font.weight(type: Config.shared.model?.createPreScreen?.descriptionFontWeight ?? 400))

		createRequestButton.backgroundColor = Colors.createPreScreenButtonBackgroundColor
		createRequestButton.layer.borderColor = Colors.createPreScreenButttonBorderColor.cgColor
		createRequestButton.setTitleColor(Colors.createPreScreenButtonTextColor, for: .normal)
		createRequestButton.tintColor = Colors.createPreScreenButtonTextColor
		createRequestButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.createPreScreen?.buttonTextFontSize ?? 14), weight: Font.weight(type: Config.shared.model?.createPreScreen?.buttonTextFontWeight ?? 400))
		createRequestButton.setTitle(Config.shared.model?.createPreScreen?.buttonText, for: .normal)
		bottomDescriptionLabel.text = Config.shared.model?.createPreScreen?.bottomNoteText
		bottomDescriptionLabel.textColor = Colors.bottomNoteColor
		bottomDescriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(Config.shared.model?.generalSettings?.bottomNoteFontSize ?? 8), weight: Font.weight(type: Config.shared.model?.generalSettings?.bottomNoteFontWeight ?? 400))
		bottomDescriptionLabel.sizeToFit()
		bottomScrollView.isHidden = !(Config.shared.model?.createPreScreen?.bottomNoteIsHidden ?? false)
		bottomScrollView.isUserInteractionEnabled = Config.shared.model?.createPreScreen?.bottomNoteIsHidden ?? false

		configureButton()

	}
	
	/// Configure for create request preview button
	func configureButton() {
		let type = Config.shared.model?.createPreScreen?.buttonStyleId

		let imageIshidden =  Config.shared.model?.createPreScreen?.buttonIconIsHidden ?? true
		let buttonShadowIsHidden = Config.shared.model?.createPreScreen?.buttonShadowIsHidden ?? true

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
			createRequestButton.imageView?.tintColor = Colors.createPreScreenButtonTextColor

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
extension CreatRequestPreView {

	/// Returns width or height, whichever is the smaller value.
	func minDimension(size: CGSize) -> CGFloat {
		return min(size.width, size.height)
	}

}
