//
//  Beacon.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import Foundation
import APIKit

struct Beacon {
    let id: UUID?
    var major: Int?
    var minor: Int?
    var organizationId: Int?
    var status: Int?
    var latitude: Double
    var longitude: Double
}

extension Beacon: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case organizationId = "organization_id"
        case major
        case minor
        case status
        case latitude
        case longitude
    }
}

extension Beacon: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .convertFromString(positiveInfinity: "+veInfinity", negativeInfinity: "-veInfinity", nan: "nan"))
    }
}
