//
//  Podcast.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation
import CoreData

public struct PodcastViewModel: WebObject {

    public var id: Int64
    public let title: String?
    public let image: URL?
    public let feed: String?
    public let podcastDescription: String?

    internal init(from podcast: PodcastStorageObject) {
        self.id = podcast.id
        self.title = podcast.title
        self.image = podcast.image
        self.feed = podcast.feed
        self.podcastDescription = podcast.podcastDescription
    }

    public init(id: Int64, title: String?, image: URL?, podcastDescription: String?, feed: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.feed = feed
        self.podcastDescription = podcastDescription
    }

}
