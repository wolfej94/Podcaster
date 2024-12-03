//
//  MockCoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

@testable import Storage
import CoreData
import Combine

struct MockCoreDataHelper: CoreDataHelper {

    var errorToThrowForBatchInsert: Error?
    var errorToThrowForBatchDelete: Error?
    var errorToThrowForSaveAndRelateEpisodes: Error?
    var errorToThrowForFetchObjectIDs: Error?
    var errorToThrowForFetchObject: Error?
    var errorToThrowForFetchObjects: Error?

    var dataToReturnForFetchObjectIDs: [NSManagedObjectID]?
    var dataToReturnForFetchObject: NSManagedObject?
    var dataToReturnForFetchObjects: [NSManagedObject]?

    func batchInsert(entityName: String, objects: [[String : Any]], in context: NSManagedObjectContext) async throws {
        if let errorToThrowForBatchInsert { throw errorToThrowForBatchInsert }
    }
    
    func batchDelete(objectIDs: [NSManagedObjectID], in context: NSManagedObjectContext) async throws {
        if let errorToThrowForBatchDelete { throw errorToThrowForBatchDelete }
    }
    
    func saveAndRelateEpisodes(_ episodes: [Storage.EpisodeStorageObject], to podcast: Storage.PodcastStorageObject, in context: NSManagedObjectContext) async throws {
        if let errorToThrowForSaveAndRelateEpisodes { throw errorToThrowForSaveAndRelateEpisodes }
    }
    
    func batchInsert(entityName: String, objects: [[String : Any]], in context: NSManagedObjectContext, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let errorToThrowForBatchInsert {
            completion(.failure(errorToThrowForBatchInsert))
            return
        }
    }
    
    func batchDelete(objectIDs: [NSManagedObjectID], in context: NSManagedObjectContext, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let errorToThrowForBatchDelete {
            completion(.failure(errorToThrowForBatchDelete))
            return
        }
    }
    
    func saveAndRelateEpisodes(_ episodes: [Storage.EpisodeStorageObject], to podcast: Storage.PodcastStorageObject, in context: NSManagedObjectContext, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let errorToThrowForSaveAndRelateEpisodes {
            completion(.failure(errorToThrowForSaveAndRelateEpisodes))
            return
        }
    }
    
    func batchInsertPublisher(entityName: String, objects: [[String : Any]], in context: NSManagedObjectContext) -> AnyPublisher<Void, any Error> {
        if let errorToThrowForBatchDelete {
            return Fail(error: errorToThrowForBatchDelete).eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func batchDeletePublisher(objectIDs: [NSManagedObjectID], in context: NSManagedObjectContext) -> AnyPublisher<Void, any Error> {
        if let errorToThrowForBatchDelete {
            return Fail(error: errorToThrowForBatchDelete).eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveAndRelateEpisodesPublisher(_ episodes: [Storage.EpisodeStorageObject], to podcast: Storage.PodcastStorageObject, in context: NSManagedObjectContext) -> AnyPublisher<Void, any Error> {
        if let errorToThrowForSaveAndRelateEpisodes {
            return Fail(error: errorToThrowForSaveAndRelateEpisodes).eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchObjectIDs<T>(ofType type: T.Type, for ids: [String], in context: NSManagedObjectContext) throws -> [NSManagedObjectID] where T : NSManagedObject {
        if let errorToThrowForFetchObjectIDs {
            throw errorToThrowForFetchObjectIDs
        }
        return dataToReturnForFetchObjectIDs ?? []
    }
    
    func fetchManagedObject<T>(ofType type: T.Type, byID id: String, in context: NSManagedObjectContext) throws -> T? where T : NSManagedObject {
        if let errorToThrowForFetchObject {
            throw errorToThrowForFetchObject
        }
        return dataToReturnForFetchObject as? T
    }
    
    func fetchManagedObjects<T>(ofType type: T.Type, byIDs ids: [String], in context: NSManagedObjectContext) throws -> [T] where T : NSManagedObject {
        if let errorToThrowForFetchObjects {
            throw errorToThrowForFetchObjects
        }
        return dataToReturnForFetchObjects as? [T] ?? []
    }

}
