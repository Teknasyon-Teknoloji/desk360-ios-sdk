//
//  Collection+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import Foundation

extension Collection {

	/// Safe protects the array from out of bounds by use of optional.
	///
	///        let arr = [1, 2, 3, 4, 5]
	///        arr[safe: 1] -> 2
	///        arr[safe: 10] -> nil
	///
	/// - Parameter index: index of element to access element.
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}

}
