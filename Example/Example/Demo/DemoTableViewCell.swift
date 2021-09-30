//
//  DemoItemTableViewCell.swift
//  Example
//
//  Created by samet on 16.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

final class DemoTableViewCell: UITableViewCell, Reusable, Layoutable {

	lazy var containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.addSubview(verticalStackView)
		view.addSubview(switchControl)
		return view
	}()

	lazy var switchControl: UISwitch = {
		let aSwitch = UISwitch()
		aSwitch.isOn = true
		aSwitch.contentCompressionResistancePriority(for: .vertical)
		return aSwitch
	}()

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = .black
		label.textAlignment = .center
		label.contentCompressionResistancePriority(for: .vertical)
		return label
	}()

	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 12, weight: .light)
		label.textColor = .black
		label.textAlignment = .center
		label.contentCompressionResistancePriority(for: .vertical)
		return label
	}()

	var items: [String] {
		return ["test", "production"]
	}

	lazy var segmentedControl: UISegmentedControl = {
		let segmentControl = UISegmentedControl(items: items)
		segmentControl.selectedSegmentIndex = 0
		segmentControl.contentCompressionResistancePriority(for: .vertical)
//		segmentControl.backgroundColor = UIColor
//		segmentControl.tintColor = Colors.darkGreyBlueTwo
//		if #available(iOS 13.0, *) {
//			segmentControl.selectedSegmentTintColor = Colors.darkGreyBlueTwo
//		}
//		segmentControl.ars.borderColor = Colors.darkBlueGrey
//
//		let selectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
//								  NSAttributedString.Key.font: FontFamily.ProximaNova.regular.font(size: 22)]
//
//		let unSelectedattributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.25),
//									NSAttributedString.Key.font: FontFamily.ProximaNova.regular.font(size: 22)]
//		segmentControl.setTitleTextAttributes(unSelectedattributes as [NSAttributedString.Key: Any], for: .normal)
//		segmentControl.setTitleTextAttributes(selectedattributes as [NSAttributedString.Key: Any], for: .selected)
		return segmentControl
	}()

	private lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.spacing = preferredSpacing * 0.25
		stackView.addArrangedSubview(segmentedControl)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(descriptionLabel)
		return stackView
	}()

	private lazy var horizontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fillProportionally
		stackView.spacing = preferredSpacing * 0.1
		stackView.addArrangedSubview(verticalStackView)
		stackView.addArrangedSubview(switchControl)
		return stackView
	}()

	func setupViews() {
		backgroundColor = .clear
		selectionStyle = .none
		addSubview(containerView)
//		addSubview(switchControl)
//		addSubview(segmentedControl)
	}

	func setupLayout() {
		switchControl.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(preferredSpacing * 0.5)
			make.centerY.equalToSuperview()
		}

		containerView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
		}

		verticalStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(preferredSpacing * 1.5)
			make.bottom.top.equalToSuperview().inset(preferredSpacing * 0.5)
		}
//		segmentedControl.snp.makeConstraints { make in
//			make.height.equalTo(preferredSpacing * 1.5)
//		}
//
//		titleLabel.snp.makeConstraints { make in
//			make.height.greaterThanOrEqualTo(preferredSpacing * 1.5)
//		}
//
//		descriptionLabel.snp.makeConstraints { make in
//			make.height.greaterThanOrEqualTo(preferredSpacing * 1.5)
//		}

//		stackView.snp.makeConstraints { make in
//			make.leading.top.bottom.equalToSuperview().inset(preferredSpacing * 0.5)
//			make.trailing.equalTo(switchControl.snp.leading).offset(-preferredSpacing * 0.5)
//		}
	}

	func configure(for item: DemoItem ) {
		titleLabel.text = item.title
		descriptionLabel.text = item.description ?? ""
		segmentedControl.isHidden = !item.isSegmentedControl
		switchControl.isHidden = !item.isSwitch
		titleLabel.alpha = 1
		descriptionLabel.alpha = 1
		descriptionLabel.isHidden = false
		titleLabel.textAlignment = item.isSwitch ? .right : .center
		switch item {
		case .environment:
			if Stores.environment.object ?? "" == "test" {
				segmentedControl.selectedSegmentIndex = 0
			} else {
				segmentedControl.selectedSegmentIndex = 1
			}
		case .jsonData:
			descriptionLabel.text = "device id: " + "\(Stores.deviceId.object ?? "")" + "\n" + "appName: DemoApp"
			titleLabel.alpha = Stores.useJsonData.object ?? false ? 1 : 0.7
			descriptionLabel.isHidden = !(Stores.useJsonData.object ?? false)
		case .language:
			descriptionLabel.text = Stores.currentLanguage.object?.name
			guard Stores.useDeviceLanguage.object ?? false else { return }
			titleLabel.alpha = 0.5
			descriptionLabel.alpha = 0.7
		case .rightAppId:
			break
		case .useDeviceLanguage:
			switchControl.isOn = Stores.useDeviceLanguage.object ?? false
//			descriptionLabel.isHidden = !(Stores.useDeviceLanguage.object ?? false)
		case .useJsonData:
			switchControl.isOn = Stores.useJsonData.object ?? false
		}
		guard item == .language else { return }

	}
//
//	func configure(for source: ReferralSource) {
//		textLabel?.text = source.title
//	}

}
