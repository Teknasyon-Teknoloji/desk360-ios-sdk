//
//  ListingView.swift
//  Desk360
//
//  Created by samet on 16.05.2019.
//

import UIKit

class ListingView: UIView, Layoutable, Loadingable {

	lazy var placeholderView: ListingPlaceholderView = {
		let view = ListingPlaceholderView.create()
		view.isHidden = true
		return view
	}()

	lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.contentInset = UIEdgeInsets(top: preferredSpacing, left: 0, bottom: preferredSpacing, right: 0)
		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 90.0
		view.backgroundColor = .red
		return view
	}()

	private lazy var desk360Label: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.currentTheme.desk360LabelTextColor
		label.text = "Desk360"
		label.font = UIFont.systemFont(ofSize: 12)
		label.textAlignment = .center
		return label
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			tableView.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		backgroundColor = Desk360.Config.currentTheme.backgroundColor
		addSubview(tableView)
		addSubview(desk360Label)
		addSubview(placeholderView)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360Label.snp.top).offset(-preferredSpacing * 0.5)
		}

		desk360Label.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(preferredSpacing)
//			make.height.equalTo(preferredSpacing)
			make.bottom.equalTo(safeArea.bottom).offset(-preferredSpacing * 0.5)
		}

		placeholderView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360Label.snp.top).offset(-preferredSpacing * 0.5)
		}
	}

	func showPlaceholder(_ show: Bool) {
		placeholderView.isHidden = !show
	}

}
