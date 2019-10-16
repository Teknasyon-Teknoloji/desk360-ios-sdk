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

	private lazy var desk360BottomView: UIView = {
		let view = UIView()
		view.backgroundColor =  Desk360.Config.currentTheme.desk360ViewBackgroundColor
		view.addSubview(self.desk360Label)
		view.addSubview(self.poweredByLabel)
		return view
	}()

	private lazy var desk360Label: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.currentTheme.desk360LabelTextColor
		label.text = " DESK360 "
		label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
		label.textAlignment = .right
		return label
	}()

	private lazy var poweredByLabel: UILabel = {
		let label = UILabel()
		label.textColor = Desk360.Config.currentTheme.desk360LabelTextColor
		label.text = "powered by"
		label.font = UIFont.systemFont(ofSize: 12)
		label.textAlignment = .right
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
		addSubview(desk360BottomView)
		addSubview(placeholderView)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360BottomView.snp.top).offset(-preferredSpacing * 0.5)
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

		placeholderView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(desk360BottomView.snp.top).offset(-preferredSpacing * 0.5)
		}
	}

	func showPlaceholder(_ show: Bool) {
		placeholderView.isHidden = !show
	}

}
