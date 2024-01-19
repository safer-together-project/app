//
//  Path.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import Foundation

public struct Path {
    var id: Int?
    var reportId: Int?
    var date: Date
    var points: [Point] = []
}

extension Path: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case reportId = "report_id"
        case date
        case points
    }
}

extension Path: Hashable { }

extension Path: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension Path: CustomEncodingStrategy {
    static var encodingStrategies: EncodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}
