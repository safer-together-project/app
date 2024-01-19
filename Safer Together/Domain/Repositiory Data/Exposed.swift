//
//  Exposed.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/22/22.
//

import Foundation

public struct ExposedDomain {
    var id: UUID?
    var reportId: Int64
    var exposedDate: Date
    var duration: Double
    var infectionName: String
    var infectionTypeValue: Int16
}

extension ExposedDomain: Hashable { }

extension ExposedDomain: CoreDataRepresentable {
    func indentifierPredicate() -> NSPredicate {
        if let id = id {
            return NSPredicate(format: "id == %@", id.uuidString)
        } else {
            return NSPredicate()
        }
    }

    func update(entity: ExposedMO) {
        if let id = id {
            entity.id = id
        }

        entity.reportId = reportId
        entity.exposedDate = exposedDate
        entity.duration = duration
        entity.infectionName = infectionName
        entity.infectionTypeValue = infectionTypeValue
    }
}
