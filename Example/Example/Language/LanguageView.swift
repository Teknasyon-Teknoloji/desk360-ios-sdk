//
//  LanguageView.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

final class LanguageView: UIView, Layoutable {

	lazy var tableView: UITableView = {
		let view = UITableView(frame: frame, style: .grouped)
		view.isOpaque = false
		view.showsVerticalScrollIndicator = false
		view.separatorStyle = .none

		view.estimatedRowHeight = 70
		view.rowHeight = UITableView.automaticDimension
		view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)

		return view
	}()

	lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		button.imageView?.tintColor = .black
		return button
	}()

	func setupViews() {
		backgroundColor = UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
		addSubview(tableView)
		addSubview(closeButton)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { $0.edges.equalToSuperview() }

		closeButton.snp.makeConstraints { make in
			make.trailing.top.equalToSuperview().inset(preferredSpacing * 0.5)
			make.width.height.equalTo(preferredSpacing * 1.5)
		}
	}

}

