//
//  CombineCoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Combine
import CoreData

internal protocol CombineCoreDataHelper {

    func batchInsertPublisher(entityName: String,
                              objects: [[String: Any]],
                              in context: NSManagedObjectContext) -> AnyPublisher<Void, Error>

    func batchDeletePublisher(objectIDs: [NSManagedObjectID],
                              in context: NSManagedObjectContext) -> AnyPublisher<Void, Error>

    func saveAndRelateEpisodesPublisher(
        _ episodes: [EpisodeStorageObject],
        to podcast: PodcastStorageObject,
        in context: NSManagedObjectContext) -> AnyPublisher<Void, Error>

}
