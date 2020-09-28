//
//  Attachment.swift
//  Desk360
//
//  Created by Mustafa Yazgülü on 18.09.2020.
//

import Foundation

public struct Attachment {

    var images: [AttachObject]?
    var videos: [AttachObject]?
    var files: [AttachObject]?
    var others: [AttachObject]?
}

extension Attachment: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case images
        case videos
        case files
        case others
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: Decoding error.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            images = try container.decodeIfPresent([AttachObject].self, forKey: .images)
            videos = try container.decodeIfPresent([AttachObject].self, forKey: .videos)
            files = try container.decodeIfPresent([AttachObject].self, forKey: .files)
            others = try container.decodeIfPresent([AttachObject].self, forKey: .others)
        } catch let error as DecodingError {
            print(error)
            throw error
        }
    }

    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Encoding error.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        do {
            try container.encodeIfPresent(images, forKey: .images)
            try container.encodeIfPresent(videos, forKey: .videos)
            try container.encodeIfPresent(files, forKey: .files)
            try container.encodeIfPresent(others, forKey: .others)
        } catch let error as EncodingError {
            print(error)
            throw error
        }
    }
}

public struct AttachObject {

    var url: String
    var name: String
    var type: String
}

extension AttachObject: Codable {
    private enum CodingKeys: String, CodingKey {
        case url
        case name
        case type
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: Decoding error.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            url = try container.decode(String.self, forKey: .url)
            name = try container.decode(String.self, forKey: .name)
            type = try container.decode(String.self, forKey: .type)
        } catch let error as DecodingError {
            print(error)
            throw error
        }
    }

    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Encoding error.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        do {
            try container.encode(url, forKey: .url)
            try container.encode(name, forKey: .name)
            try container.encode(type, forKey: .type)

        } catch let error as EncodingError {
            print(error)
            throw error
        }
    }
}
