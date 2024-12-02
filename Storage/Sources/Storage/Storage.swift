// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreData

public final class Storage {

    private let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext

    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MVVM_C")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error {
                fatalError("Unresolved error \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
    }

    public func create<T: StorageObject>(_ objects: [T]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            backgroundContext.performAndWait {
                do {
                    let values = try objects.reduce(into: [[String: Any]]()) { result, object in
                        result = try result + [object.toDictionary()]
                    }
                    let batchInsertRequest = NSBatchInsertRequest(entityName: T.manageObjectType.entity().name ?? "", objects: values)
                    try backgroundContext.execute(batchInsertRequest)
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func read<T: StorageObject>(predicate: NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil) throws -> [T] {
        let entityType = T.manageObjectType.entity().name ?? ""
        let fetchRequest = NSFetchRequest<T.manageObjectType>(entityName: entityType)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortBy
        return try container.viewContext
            .fetch(fetchRequest)
            .map {
                T.init(from: $0)
            }
    }

    public func delete(_ objects: [any StorageObject]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            backgroundContext.performAndWait {
                do {
                    let batchInsertRequest = NSBatchDeleteRequest(objectIDs: objects.compactMap(\.managedObjectId))
                    try backgroundContext.execute(batchInsertRequest)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}
