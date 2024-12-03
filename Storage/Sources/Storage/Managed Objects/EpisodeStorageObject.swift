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

}
