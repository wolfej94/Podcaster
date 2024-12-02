// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreData

public final class Storage {

    private let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext

    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Storage")
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

    public func create(_ podcasts: [Podcast]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            backgroundContext.performAndWait {
                do {
                    let values = try podcasts.reduce(into: [[String: Any]]()) { result, object in
                        result = try result + [object.toDictionary()]
                    }
                    let batchInsertRequest = NSBatchInsertRequest(entityName: "PodcastStorageObject", objects: values)
                    try backgroundContext.execute(batchInsertRequest)
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func read(predicate: NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil) throws -> [Podcast] {
        let fetchRequest = NSFetchRequest<PodcastStorageObject>(entityName: "PodcastStorageObject")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortBy
        return try container.viewContext
            .fetch(fetchRequest)
            .map {
                Podcast(from: $0)
            }
    }

    public func delete(_ objects: [Podcast]) async throws {
        let managedObjectIDs = try objects.compactMap {
            let fetchRequest = NSFetchRequest<PodcastStorageObject>(entityName: "PodcastStorageObject")
            fetchRequest.predicate = NSPredicate(format: "id = %@", $0.id)
            return try container.viewContext.fetch(fetchRequest).first?.objectID
        }
        return try await withCheckedThrowingContinuation { continuation in
            backgroundContext.performAndWait {
                do {
                    let batchInsertRequest = NSBatchDeleteRequest(objectIDs: managedObjectIDs)
                    try backgroundContext.execute(batchInsertRequest)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}
