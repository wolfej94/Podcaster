//
//  AsyncCoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import CoreData

internal protocol AsyncCoreDataHelper {

    func batchInsert(entityName: String,
                     objects: [[String: Any]],
                     in context: NSManagedObjectContext) async throws



    func batchDelete(objectIDs: [NSManagedObjectID],
                     in context: NSManagedObjectContext) async throws

    func saveAndRelateEpisodes(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext) async throws

}
