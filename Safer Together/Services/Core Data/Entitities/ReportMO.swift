//
//  ReportMO.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import Foundation
import CoreData

@objc(ReportMO)
public final class ReportMO: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var infectionConditionId: Int64
    @NSManaged public var organizationId: Int64
    @NSManaged public var created: Date
    @NSManaged public var infectionName: String
    @NSManaged public var infectionTypeValue: Int16
}

extension ReportMO: Persistable {
    func asDomain() -> ReportDomain {
        return ReportDomain(
            id: id,
            organizationId: organizationId,
            infectionConditionId: infectionConditionId,
            created: created,
            infectionName: infectionName,
            infectionTypeValue: InfectionType(rawValue: Int(infectionTypeValue)) ?? .unknown
        )
    }

    static func createFetchRequest() -> NSFetchRequest<ReportMO> {
        return NSFetchRequest<ReportMO>(entityName: ReportMO.entityName)
    }

    static var entityName: String {
        return "ReportMO"
    }
}
