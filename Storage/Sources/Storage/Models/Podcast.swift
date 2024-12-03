//
//  Podcast.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation
import CoreData

public struct Podcast: StorageObject {

    public let id: String
    public let email: String
    public let image: URL?
    public let title: String
    public let country: String
    public let website: URL?
    public let language: String
    public let genres: [Genre]
    public let publisher: String
    public let thumbnail: URL?
    public let summary: String
    public let listenScore: Int
    public let totalEpisodes: Int
    public let explicitContent: Bool
    public let latestEpisodeID: String
    public let latestPubDateMS: Date?
    public let earliestPubDateMS: Date?
    public let updateFrequencyHours: Int
    public let listenScoreGlobalRank: String
    public let episodes: [Episode]

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case image
        case title
        case country
        case website
        case language
        case genres
        case publisher
        case thumbnail
        case summary
        case listenScore = "listen_score"
        case totalEpisodes = "total_episodes"
        case explicitContent = "explicit_content"
        case latestEpisodeID = "latest_episode_id"
        case latestPubDateMS = "latest_pub_date_ms"
        case earliestPubDateMS = "earliest_pub_date_ms"
        case updateFrequencyHours = "update_frequency_hours"
        case listenScoreGlobalRank = "listen_score_global_rank"
    }

    internal init(from: PodcastStorageObject) {
        id = from.id ?? ""
        email = from.email ?? ""
        image = from.image
        title = from.title ?? ""
        country = from.country ?? ""
        website = from.website
        language = from.language ?? ""
        genres = (from.genres?.allObjects as? [GenreStorageObject])?
            .map { Genre(id: Int($0.id)) } ?? []
        publisher = from.publisher ?? ""
        thumbnail = from.thumbnail
        summary = from.summary ?? ""
        listenScore = Int(from.listenScore)
        totalEpisodes = Int(from.totalEpisodes)
        explicitContent = from.explicitContent
        latestEpisodeID = from.latestEpisodeID ?? ""
        latestPubDateMS = from.latestPubDateMS
        earliestPubDateMS = from.earliestPubDateMS
        updateFrequencyHours = Int(from.updateFrequencyHours)
        listenScoreGlobalRank = from.listenScoreGlobalRank ?? ""
        episodes = (from.episodes?.allObjects as? [EpisodeStorageObject])?
            .map { Episode(from: $0) } ?? []
    }

    public init(id: String, email: String, image: URL?, title: String, country: String, website: URL?, language: String, genres: [Genre], publisher: String, thumbnail: URL?, summary: String, listenScore: Int, totalEpisodes: Int, explicitContent: Bool, latestEpisodeID: String, latestPubDateMS: Date?, earliestPubDateMS: Date?, updateFrequencyHours: Int, listenScoreGlobalRank: String, episodes: [Episode]) {
        self.id = id
        self.email = email
        self.image = image
        self.title = title
        self.country = country
        self.website = website
        self.language = language
        self.genres = genres
        self.publisher = publisher
        self.thumbnail = thumbnail
        self.summary = summary
        self.listenScore = listenScore
        self.totalEpisodes = totalEpisodes
        self.explicitContent = explicitContent
        self.latestEpisodeID = latestEpisodeID
        self.latestPubDateMS = latestPubDateMS
        self.earliestPubDateMS = earliestPubDateMS
        self.updateFrequencyHours = updateFrequencyHours
        self.listenScoreGlobalRank = listenScoreGlobalRank
        self.episodes = episodes
    }

    public func toDictionary() throws -> [String : Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw StorageObjectError.serialisationFailed
        }
        return dictionary
    }

}
