import Foundation
import CoreData

protocol Persistable: NSFetchRequestResult, DomainConvertibleType {
    static var entityName: String { get }
    static func createFetchRequest() -> NSFetchRequest<Self>
}
