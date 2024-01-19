//
//  Employee.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation

struct Employee {
    let firstName: String
    let lastName: String
    let organizationId: Int
}

extension Employee: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case organizationId = "organization_id"
    }
}

extension Employee: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension Employee: CustomEncodingStrategy {
    static var encodingStrategies: EncodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}
