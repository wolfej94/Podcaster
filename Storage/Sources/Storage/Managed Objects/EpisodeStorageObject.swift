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

    @NSManaged public var audio: URL?
    @NSManaged public var audioLengthSEC: Int16
    @NSManaged public var explicitContent: Bool
    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var pubDateMS: Date?
    @NSManaged public var summary: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var title: String?
    @NSManaged public var availabileOffline: Bool
    @NSManaged public var podcast: PodcastStorageObject?

    /// To be used for testing only
    internal convenience init(episode: Episode, podcast: PodcastStorageObject? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        self.audio = episode.audio
        self.audioLengthSEC = Int16(episode.audioLengthSEC)
        self.explicitContent = episode.explicitContent
        self.id = episode.id
        self.image = episode.image
        self.pubDateMS = episode.pubDateMS
        self.summary = episode.summary
        self.thumbnail = episode.thumbnail
        self.title = episode.title
        self.availabileOffline = episode.availableOffline
        self.podcast = podcast
    }
}
