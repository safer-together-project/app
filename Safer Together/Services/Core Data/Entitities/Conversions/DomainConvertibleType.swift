import Foundation
import CoreData

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: Persistable

    func indentifierPredicate() -> NSPredicate
    func update(entity: CoreDataType)
}

extension CoreDataRepresentable {
    func sync(in context: NSManagedObjectContext) -> Result<CoreDataType, Error> {
        let predicate = indentifierPredicate()
        let request = CoreDataType.createFetchRequest()
        request.predicate = predicate

        do {
            let result = try context.fetch(request).first ?? context.create()
            update(entity: result)
            return .success(result)
        } catch {
            return .failure(CoreDataError.dataNotFound)
        }
    }
}

extension NSManagedObjectContext {
    func create<T: NSFetchRequestResult>() -> T {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self),
                into: self) as? T else {
            fatalError()
        }
        return entity
    }
}
