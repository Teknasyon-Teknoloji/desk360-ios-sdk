//
//  LanguageTableViewCell.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell, Layoutable, Reusable {

	private lazy var nameLabel: UILabel = {
		let label = UILabel( )
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .black
		label.numberOfLines = 2
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		return label
	}()

	private lazy var chevronImageView: UIImageView = {
		let view = UIImageView(image: #imageLiteral(resourceName: "arrowIcon"))
		view.contentMode = .scaleAspectFit
		view.tintColor = .black
		return view
	}()

	private lazy var containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()

	override var backgroundColor: UIColor? {
		didSet {
			nameLabel.backgroundColor = .clear
			chevronImageView.backgroundColor = .clear
		}
	}

	func setupViews() {
		backgroundColor = UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
		selectionStyle = .none
		separatorInset = .init(top: 0, left: preferredSpacing, bottom: 0, right: 0)

		containerView.addSubview(nameLabel)
		containerView.addSubview(chevronImageView)

		addSubview(containerView)
	}

	func setupLayout() {
		nameLabel.snp.makeConstraints { make in
			make.leading.trailing.equalTo(preferredSpacing)
			make.top.bottom.equalToSuperview()
		}

		chevronImageView.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(preferredSpacing)
			make.centerY.equalToSuperview()
			make.width.equalTo(8)
			make.height.equalTo(13)
		}

		containerView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalToSuperview()
			make.bottom.equalToSuperview().inset(preferredSpacing / 4)
			make.height.equalTo(preferredSpacing * 3)
		}
	}

}

// MARK: - Configure
extension LanguageTableViewCell {

	func configure(for language: Language) {
		nameLabel.text = language.name
	}

}
