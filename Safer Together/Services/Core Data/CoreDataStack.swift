//
//  CoreDataStack.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import CoreData

final class CoreDataStack {
    private let storeCoordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext

    public init() {
        let bundle = Bundle(for: CoreDataStack.self)
        guard let url = bundle.url(forResource: "Steds_Care", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError()
        }
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.storeCoordinator
        self.migrateStore()
    }

    private func migrateStore() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError()
        }
        let storeUrl = url.appendingPathComponent("Steds_Care.sqlite")
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                    configurationName: nil,
                                                    at: storeUrl,
                                                    options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}
