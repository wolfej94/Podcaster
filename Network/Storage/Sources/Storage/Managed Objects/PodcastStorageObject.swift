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
internal class PodcastStorageObject: NSManagedObject {

    @NSManaged public var country: String?
    @NSManaged public var earliestPubDateMS: Date?
    @NSManaged public var email: String?
    @NSManaged public var explicitContent: Bool
    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var language: String?
    @NSManaged public var latestEpisodeID: String?
    @NSManaged public var latestPubDateMS: Date?
    @NSManaged public var listenScore: Int16
    @NSManaged public var listenScoreGlobalRank: String?
    @NSManaged public var publisher: String?
    @NSManaged public var summary: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var title: String?
    @NSManaged public var totalEpisodes: Int16
    @NSManaged public var updateFrequencyHours: Int16
    @NSManaged public var website: URL?
    @NSManaged public var episodes: NSSet?
    @NSManaged public var genres: NSSet?

    /// To be used for testing only
    internal convenience init(podcast: Podcast, context: NSManagedObjectContext) {
        self.init(context: context)
        self.country = podcast.country
        self.earliestPubDateMS = podcast.earliestPubDateMS
        self.email = podcast.email
        self.explicitContent = podcast.explicitContent
        self.id = podcast.id
        self.image = podcast.image
        self.language = podcast.language
        self.latestEpisodeID = podcast.latestEpisodeID
        self.latestPubDateMS = podcast.latestPubDateMS
        self.listenScore = Int16(podcast.listenScore)
        self.listenScoreGlobalRank = podcast.listenScoreGlobalRank
        self.publisher = podcast.publisher
        self.summary = podcast.summary
        self.thumbnail = podcast.thumbnail
        self.title = podcast.title
        self.totalEpisodes = Int16(podcast.totalEpisodes)
        self.updateFrequencyHours = Int16(podcast.updateFrequencyHours)
        self.website = podcast.website
        self.episodes = NSSet(array: podcast.episodes
            .map {
                EpisodeStorageObject(episode: $0, context: context)
            })
        self.genres = NSSet(array: podcast.genres
            .map {
                GenreStorageObject(genre: $0, context: context)
            })
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

// MARK: Generated accessors for genres
extension PodcastStorageObject {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: GenreStorageObject)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: GenreStorageObject)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

