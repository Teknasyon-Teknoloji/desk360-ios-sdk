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

	internal lazy var tableView: UITableView = {
		let view = UITableView()
		view.separatorStyle = .none
		view.contentInset = UIEdgeInsets(top: preferredSpacing, left: 0, bottom: preferredSpacing, right: 0)

		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 90.0

		return view
	}()

	public override var backgroundColor: UIColor? {
		didSet {
			tableView.backgroundColor = backgroundColor
		}
	}

	func setupViews() {
		backgroundColor = Desk360.Config.Requests.Listing.backgroundColor
		addSubview(tableView)
		addSubview(placeholderView)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { $0.edges.equalToSuperview() }

		placeholderView.snp.makeConstraints { $0.edges.equalToSuperview()}
	}

	func showPlaceholder(_ show: Bool) {
		placeholderView.isHidden = !show
	}

}
