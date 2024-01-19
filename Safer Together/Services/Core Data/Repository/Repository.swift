//
//  Repository.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import Foundation
import CoreData

protocol AbstractRepository {
    associatedtype T
    func query(with predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]?) -> Result<[T], Error>
    func save(entity: T) -> Result<Void, Error>
    func delete(entity: T) -> Result<Void, Error>
}

final class Repository<T: CoreDataRepresentable>: AbstractRepository where T == T.CoreDataType.DomainType {
    private let context: NSManagedObjectContext

    enum RepositoryError: Error {
        case invalidManagedObjectType
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func query(with predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor]? = nil) -> Result<[T], Error> {
        let request = T.CoreDataType.createFetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            let fetchedResults = try context.fetch(request).map { $0.asDomain() }
            return .success(fetchedResults)
        } catch {
            return .failure(error)
        }
    }

    func save(entity: T) -> Result<Void, Error> {
        return entity.sync(in: context)
            .flatMap { _ in
                do {
                    try context.save()
                    return .success(())
                } catch {
                    return .failure(RepositoryError.invalidManagedObjectType)
                }
            }
    }

    func delete(entity: T) -> Result<Void, Error> {
        return entity.sync(in: context)
            .flatMap { object in

                if let object = object as? NSManagedObject {
                    context.delete(object)
                    return .success(())
                } else {
                    return .failure(RepositoryError.invalidManagedObjectType)
                }
            }
    }
}
