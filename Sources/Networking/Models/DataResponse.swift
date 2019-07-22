//
//  DataResponse.swift
//  Desk360
//
//  Created by samet on 20.05.2019.
//

import Foundation

struct DataResponse<D: Codable>: Codable {

	var data: D?

}
