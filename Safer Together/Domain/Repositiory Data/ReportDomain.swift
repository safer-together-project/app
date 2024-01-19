//
//  ReportDomain.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/20/22.
//

import Foundation


struct ReportDomain: ReportBase {
    var id: Int64?
    var organizationId: Int64
    var infectionConditionId: Int64
    var created: Date

    var infectionName: String
    var infectionTypeValue: InfectionType
}

extension ReportDomain: Hashable { }

extension ReportDomain: CoreDataRepresentable {
    func indentifierPredicate() -> NSPredicate {
        if let id = id {
            return NSPredicate(format: "id = \(id)")
        } else {
            return NSPredicate()
        }
    }

    func update(entity: ReportMO) {
        if let id = id {
            entity.id = id
        }

        entity.infectionConditionId = infectionConditionId
        entity.organizationId = organizationId
        entity.created = created
        entity.infectionName = infectionName
        entity.infectionTypeValue = Int16(infectionTypeValue.rawValue)
    }
}
