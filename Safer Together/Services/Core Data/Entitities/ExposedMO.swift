//
//  ExposedMO.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/22/22.
//

import CoreData

@objc(ExposedMO)
public final class ExposedMO: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var reportId: Int64
    @NSManaged public var exposedDate: Date
    @NSManaged public var duration: Double
    @NSManaged public var infectionName: String
    @NSManaged public var infectionTypeValue: Int16
}

extension ExposedMO: Persistable {
    func asDomain() -> ExposedDomain {
        return ExposedDomain(
            id: id,
            reportId: reportId,
            exposedDate: exposedDate,
            duration: duration,
            infectionName: infectionName,
            infectionTypeValue: infectionTypeValue
        )
    }

    static func createFetchRequest() -> NSFetchRequest<ExposedMO> {
        return NSFetchRequest<ExposedMO>(entityName: ExposedMO.entityName)
    }

    static var entityName: String {
        return "ExposedMO"
    }
}
