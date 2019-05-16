//
//  UIView+Extensions.swift
//  Desk360
//
//  Created by Omar on 5/13/19.
//

import UIKit
import SnapKit

extension UIView {

	/// Get `safeAreaLayoutGuide.snp` or fallback to `self.snp` if not possible.
	var safeArea: ConstraintBasicAttributesDSL {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.snp
		}
		return self.snp
	}

}
