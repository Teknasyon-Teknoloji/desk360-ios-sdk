//
//  UITableView+Extensions.swift
//  Example
//
//  Created by samet on 17.03.2020.
//  Copyright © 2020 Teknasyon. All rights reserved.
//

import UIKit

extension UITableView {

	/// Dequeue an already registered `Layoutable` and `Reusable` `UITableViewCell` from `UITableView`
	///
	/// - Parameters:
	///   - cellType: Cell class type.
	///   - style: Cell style. _default is .default_
	/// - Returns: `UITableViewCell`
	func dequeueReusableCell<C: UITableViewCell & Layoutable & Reusable>(_ cellType: C.Type, cellStyle style: UITableViewCell.CellStyle = .default) -> C {
		guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? C else {
			let newCell = C(style: style, reuseIdentifier: C.reuseIdentifier)
			newCell.setupViews()
			newCell.setupLayout()
			return newCell
		}
		return cell
	}

	/// Dequeue an already registered `Layoutable` and `Reusable` `UITableViewHeaderFooterView` from `UITableView`
	///
	/// - Parameter viewType: View class type.
	/// - Returns: `UITableViewHeaderFooterView`
	func dequeueReusableHeaderFooterView<V: UITableViewHeaderFooterView & Layoutable & Reusable>(_ viewType: V.Type) -> V {
		guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? V else {
			let newView = V(reuseIdentifier: V.reuseIdentifier)
			newView.setupViews()
			newView.setupLayout()
			return newView
		}
		return view
	}

}

