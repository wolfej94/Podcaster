//
//  ClosureCoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import CoreData

internal protocol ClosureCoreDataHelper {

    func batchInsert(entityName: String,
                     objects: [[String: Any]],
                     in context: NSManagedObjectContext,
                     completion: @escaping (Result<Void, Error>) -> Void)

    func batchDelete(objectIDs: [NSManagedObjectID],
                     in context: NSManagedObjectContext,
                     completion: @escaping (Result<Void, Error>) -> Void)

    func saveAndRelateEpisodes(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext,
        completion: @escaping (Result<Void, Error>) -> Void)

}
