//
//  Desk360Environment.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 30.09.2021.
//

import Foundation

@objc public enum Desk360Environment: Int {
    @available(*, unavailable, renamed: "sandbox", message: "Please use .sandbox option instead.")
    case test

    case sandbox
    case production

    var stringValue: String {
        switch self {
            case .test:
                return "test"
            case .sandbox:
                return "sandbox"
            case .production:
                return "production"
        }
    }
}
