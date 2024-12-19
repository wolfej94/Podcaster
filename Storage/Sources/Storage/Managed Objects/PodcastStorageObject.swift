//
//  PodcastStorageObject+CoreDataClass.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//
//
import Foundation
import CoreData

@objc(PodcastStorageObject)
internal class PodcastStorageObject: NSManagedObject, @unchecked Sendable {

    @NSManaged public var id: Int64
    @NSManaged public var image: URL?
    @NSManaged public var podcastDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var feed: String?
    @NSManaged public var explicit: Bool
    @NSManaged public var episodes: NSSet?

    convenience init(podcast:PodcastViewModel, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = podcast.id
        self.title = podcast.title
        self.image = podcast.image
        self.feed = podcast.feed
        self.podcastDescription = podcast.podcastDescription
        self.explicit = podcast.explicit
    }
}

// MARK: Generated accessors for episodes
extension PodcastStorageObject {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: EpisodeStorageObject)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: EpisodeStorageObject)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
