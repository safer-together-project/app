//
//  Infection.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/19/21.
//

import Foundation

struct Infection {
    var id: Int64
    var name: String
    var type: InfectionType
    var description: String
}

extension Infection: Hashable { }

extension Infection: Codable { }

enum InfectionType: Int, Codable {
    case unknown = 0
    case viral = 1
    case bacterial = 2
    case fungal = 3
    case parasitic = 4
}

extension InfectionType: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .viral:
            return "Viral"
        case .bacterial:
            return "Bacterial"
        case .fungal:
            return "Fungal"
        case .parasitic:
            return "Parasitic"
        }
    }
}
