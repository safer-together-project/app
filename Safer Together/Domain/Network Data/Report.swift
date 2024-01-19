//
//  Report.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import Foundation

protocol ReportBase {
    var id: Int64? { get set }
    var organizationId: Int64 { get set }
    var infectionConditionId: Int64 { get set }
    var created: Date { get set }
}

public struct Report: ReportBase {
    var id: Int64?
    var organizationId: Int64
    var infectionConditionId: Int64
    var created: Date

    var path: Path?
    var infectionCondition: InfectionCondition?
}

extension Report: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case organizationId = "organization_id"
        case infectionConditionId = "infection_condition_id"
        case created
        case path
        case infectionCondition = "infection_condition"
    }
}

extension Report: Hashable { }

extension Report: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension Report: CustomEncodingStrategy {
    static var encodingStrategies: EncodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}
