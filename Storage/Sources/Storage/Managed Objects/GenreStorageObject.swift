//
//  GenreStorageObject+CoreDataClass.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//
//

import Foundation
import CoreData

@objc(GenreStorageObject)
internal class GenreStorageObject: NSManagedObject {

    @NSManaged public var id: Int16
    @NSManaged public var podcast: PodcastStorageObject?

    /// To be used for testing only
    internal convenience init(genre: Genre, podcast: PodcastStorageObject? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int16(genre.id)
        self.podcast = podcast
    }

}
