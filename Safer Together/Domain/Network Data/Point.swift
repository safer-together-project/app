//
//  Point.swift
//  Steds Care
//
//  Created by Erik Bautista on 10/29/21.
//

import Foundation

public struct Point {
    var id: Int?
    var beaconId: UUID?
    var beaconMajor: Int?
    var beaconMinor: Int?
    var pathId: Int?
    var latitude: Double
    var longitude: Double
    var initialTimestamp: Date
    var finalTimestamp: Date
}

extension Point: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case beaconId = "beacon_id"
        case beaconMajor = "beacon_major"
        case beaconMinor = "beacon_minor"
        case pathId = "path_id"
        case latitude = "latitude"
        case longitude = "longitude"
        case initialTimestamp = "initial_timestamp"
        case finalTimestamp = "final_timestamp"
    }
}

extension Point: CustomDecodingStrategy {
    static var decodingStrategies: DecodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension Point: CustomEncodingStrategy {
    static var encodingStrategies: EncodingStrategies {
        return (.iso8601, .base64, .throw)
    }
}

extension Point: Hashable { }

extension Point: CustomStringConvertible {
    public var description: String {
        return """
        Point: (
            id: \(String(describing: id)),
            beaconId: \(String(describing: beaconId)),
            beaconMajor: \(String(describing: beaconMajor)),
            beaconMinor: \(String(describing: beaconMinor)),
            latitude: \(latitude),
            longitude: \(longitude),
            initialTimestamp: \(String(describing: initialTimestamp)),
            finalTimestamp: \(String(describing: finalTimestamp))
        )
        """
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Point(id: id, beaconId: beaconId, beaconMajor: beaconMajor, beaconMinor: beaconMinor, pathId: pathId, latitude: latitude, longitude: longitude, initialTimestamp: initialTimestamp, finalTimestamp: finalTimestamp)
        return copy
    }
}
