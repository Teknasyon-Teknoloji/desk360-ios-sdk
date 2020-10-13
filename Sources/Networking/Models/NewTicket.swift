//
//  NewTicket.swift
//  Alamofire
//
//  Created by Mustafa Yazgülü on 11.09.2020.
//

import Foundation

public struct NewTicket {

    /// Id.
    public var id: Int

    /// name.
    public var name: String
    
    /// email
    public var email: String

}

extension NewTicket: Codable {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: Decoding error.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
    }

    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Encoding error.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
    }

}

// MARK: - Identifiable
extension NewTicket: Identifiable, Equatable {

    /// Id Type.
    public static var idKey = \NewTicket.id

}
