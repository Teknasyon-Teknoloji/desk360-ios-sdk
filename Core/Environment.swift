//
//  Environment.swift
//  Alamofire
//
//  Created by Ali Ammar Hilal on 28.05.2021.
//

import Foundation

public enum Desk360Environment: String, Equatable {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
    case test
    
    case sandbox
    case production
}
