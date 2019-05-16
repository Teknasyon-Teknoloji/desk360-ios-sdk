//
//  CGSize+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/9/19.
//

import CoreGraphics

extension CGSize {

	/// Returns width or height, whichever is the bigger value.
	var maxDimension: CGFloat {
		return max(width, height)
	}

	/// Returns width or height, whichever is the smaller value.
	var minDimension: CGFloat {
		return min(width, height)
	}

}
