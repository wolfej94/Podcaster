//
//  CoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import CoreData
import Combine

typealias CoreDataHelper = SynchronousCoreDataHelper & AsyncCoreDataHelper & ClosureCoreDataHelper & CombineCoreDataHelper
internal struct DefaultCoreDataHelper: SynchronousCoreDataHelper {

    func fetchManagedObject<T: NSManagedObject>(ofType type: T.Type,
                                                byID id: String,
                                                in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return try context.fetch(fetchRequest as! NSFetchRequest<T>).first
    }

    func fetchManagedObjects<T: NSManagedObject>(ofType type: T.Type,
                                                 byIDs ids: [String]?,
                                                 in context: NSManagedObjectContext) throws -> [T] {
        let fetchRequest = T.fetchRequest()
        if let ids {
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        }
        return try context.fetch(fetchRequest as! NSFetchRequest<T>)
    }

    func fetchObjectIDs<T: NSManagedObject>(ofType type: T.Type,
                                            for ids: [String],
                                            in context: NSManagedObjectContext) throws -> [NSManagedObjectID] {
        return try ids.compactMap { id in
            try fetchManagedObject(ofType: type, byID: id, in: context)?.objectID
        }
    }

}

// MARK: - Async/Await Methods
extension DefaultCoreDataHelper: AsyncCoreDataHelper {

    func batchInsert(entityName: String,
                     objects: [[String: Any]],
                     in context: NSManagedObjectContext) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.performAndWait {
                do {
                    let batchInsertRequest = NSBatchInsertRequest(entityName: entityName, objects: objects)
                    try context.execute(batchInsertRequest)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: StorageError.unexpected(error))
                }
            }
        }
    }

    func batchDelete(objectIDs: [NSManagedObjectID],
                     in context: NSManagedObjectContext) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.performAndWait {
                do {
                    let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
                    try context.execute(deleteRequest)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: StorageError.unexpected(error))
                }
            }
        }
    }

    func saveAndRelateEpisodes(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext) async throws {
            try await withCheckedThrowingContinuation { continuation in
                context.performAndWait {
                    do {
                        podcast.addToEpisodes(NSSet(array: episodes))
                        try context.save()
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: StorageError.unexpected(error))
                    }
                }
            }
        }

}

// MARK: - Closure Methods
extension DefaultCoreDataHelper: ClosureCoreDataHelper {

    func batchInsert(entityName: String,
                     objects: [[String: Any]],
                     in context: NSManagedObjectContext,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        context.performAndWait {
            do {
                let batchInsertRequest = NSBatchInsertRequest(entityName: entityName, objects: objects)
                try context.execute(batchInsertRequest)
                completion(.success(()))
            } catch {
                completion(.failure(StorageError.unexpected(error)))
            }
        }
    }

    func batchDelete(objectIDs: [NSManagedObjectID],
                     in context: NSManagedObjectContext,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        context.performAndWait {
            do {
                let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
                try context.execute(deleteRequest)
                completion(.success(()))
            } catch {
                completion(.failure(StorageError.unexpected(error)))
            }
        }
    }

    func saveAndRelateEpisodes(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext,
        completion: @escaping (Result<Void, Error>) -> Void) {
            context.performAndWait {
                do {
                    podcast.addToEpisodes(NSSet(array: episodes))
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(StorageError.unexpected(error)))
                }
            }
        }

}


// MARK: - Combine Publisher Methods
extension DefaultCoreDataHelper: CombineCoreDataHelper {

    func batchInsertPublisher(entityName: String,
                              objects: [[String: Any]],
                              in context: NSManagedObjectContext) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            context.perform {
                do {
                    let batchInsertRequest = NSBatchInsertRequest(entityName: entityName, objects: objects)
                    try context.execute(batchInsertRequest)
                    promise(.success(()))
                } catch {
                    promise(.failure(StorageError.unexpected(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func batchDeletePublisher(objectIDs: [NSManagedObjectID],
                              in context: NSManagedObjectContext) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            context.perform {
                do {
                    let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
                    try context.execute(deleteRequest)
                    promise(.success(()))
                } catch {
                    promise(.failure(StorageError.unexpected(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func saveAndRelateEpisodesPublisher(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext) -> AnyPublisher<Void, Error> {
            Future<Void, Error> { promise in
                context.perform {
                    do {
                        podcast.addToEpisodes(NSSet(array: episodes))
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(StorageError.unexpected(error)))
                    }
                }
            }
            .eraseToAnyPublisher()
        }

}
