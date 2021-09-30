//
//  Desk360Environment.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 30.09.2021.
//

import Foundation

public enum Desk360Environment: String, Equatable {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
    case test
    
    case sandbox
    case production
}
