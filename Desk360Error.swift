//
//  Desk360Error.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 30.09.2021.
//

import Foundation

public enum Desk360Error: LocalizedError {
    case notInitalized
    
    public var errorDescription: String? {
        switch self {
        case .notInitalized: return "The Desk360 SDK is not intialized properly. Please call start(with:) first"
    
        }
    }
}
