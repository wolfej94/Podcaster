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
    public let podcastDescription: String?
    public let episodes: [EpisodeViewModel]

    internal init(from podcast: PodcastStorageObject) {
        self.id = podcast.id
        self.title = podcast.title
        self.image = podcast.image
        self.podcastDescription = podcast.podcastDescription
        self.episodes = podcast.episodes?.map { EpisodeViewModel(from: $0) } ?? []
    }

    public init(id: Int64, title: String?, image: URL?, podcastDescription: String?, episodes: [EpisodeViewModel]) {
        self.id = id
        self.title = title
        self.image = image
        self.podcastDescription = podcastDescription
        self.episodes = episodes
    }

}
