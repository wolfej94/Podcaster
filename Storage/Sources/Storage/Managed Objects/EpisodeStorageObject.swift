//
//  EpisodeStorageObject+CoreDataClass.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//
//
import Foundation
import CoreData

@objc(EpisodeStorageObject)
internal class EpisodeStorageObject: NSManagedObject, @unchecked Sendable {

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var audioLengthSEC: Int32
    @NSManaged public var explicitContent: Bool
    @NSManaged public var guid: String?
    @NSManaged public var datePublished: Date?
    @NSManaged public var episodeNumber: Int32
    @NSManaged public var enclosedURL: URL?
    @NSManaged public var season: Int32
    @NSManaged public var image: URL?
    @NSManaged public var availableOffline: Bool

    @NSManaged public var podcast: PodcastStorageObject?

    internal convenience init(episode: EpisodeViewModel, podcast: PodcastStorageObject? = nil, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = episode.id
        self.title = episode.title
        self.audioLengthSEC = episode.audioLengthSEC
        self.explicitContent = episode.explicitContent
        self.guid = episode.guid
        self.datePublished = episode.datePublished
        self.episodeNumber = episode.episodeNumber
        self.enclosedURL = episode.enclosedURL
        self.season = episode.season
        self.image = episode.image
        self.podcast = podcast
        self.availableOffline = false
    }
}
