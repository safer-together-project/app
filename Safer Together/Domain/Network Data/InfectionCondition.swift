//
//  InfectionCondition.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/19/21.
//

import Foundation


struct InfectionCondition {
    var id: Int64
    var organizationId: Int?
    var infectionId: Int?
    var maskRequired: Bool
    var distance: Double
    var duration: Double
    var infection: Infection?
}

extension InfectionCondition: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case organizationId = "organization_id"
        case infectionId = "infection_id"
        case maskRequired = "mask_required"
        case distance
        case duration
        case infection
    }
}

extension InfectionCondition: Hashable {  }

extension InfectionCondition: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension InfectionCondition: CustomEncodingStrategy {
    static var encodingStrategies: EncodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}
