//
//  Organization.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/14/21.
//

import Foundation

struct Organization {
    let id: Int64
    let accessCode: String
    let name: String
}

extension Organization: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case accessCode = "access_code"
    }
}

extension Organization: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}
