//
//  MoyaError+Networking.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import Moya

extension MoyaError {

	/// Localized message from resopnse or localizedDescription.
	var localizedServerDescription: String {
		return self.localizedDescription
	}

}
