//
//  DemoItemView.swift
//  Example
//
//  Created by samet on 16.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

final class DemoView: UIView, Layoutable {

	lazy var tableView: UITableView = {
		let view = UITableView(frame: frame, style: .grouped)
		view.showsVerticalScrollIndicator = false
		view.separatorStyle = .none
		view.rowHeight = UITableView.automaticDimension
		view.estimatedRowHeight = 400
		return view
	}()

	func setupViews() {
		backgroundColor = .white
        tableView.backgroundColor = UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
		addSubview(tableView)
	}

	func setupLayout() {
		tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}

}
