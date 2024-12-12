//
//  Podcast.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

import Foundation

public struct Podcast: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    public let email: String
    public let image: URL?
    public let title: String
    public let country: String
    public let website: URL?
    public let language: String
    public let genreIDS: [Int]
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

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case image
        case title
        case country
        case website
        case language
        case genreIDS = "genre_ids"
        case publisher
        case thumbnail
        case summary = "description"
        case listenScore = "listen_score"
        case totalEpisodes = "total_episodes"
        case explicitContent = "explicit_content"
        case latestEpisodeID = "latest_episode_id"
        case latestPubDateMS = "latest_pub_date_ms"
        case earliestPubDateMS = "earliest_pub_date_ms"
        case updateFrequencyHours = "update_frequency_hours"
        case listenScoreGlobalRank = "listen_score_global_rank"
    }

    public init(id: String, email: String, image: URL?, title: String, country: String, website: URL?, language: String, genreIDS: [Int], publisher: String, thumbnail: URL?, summary: String, listenScore: Int, totalEpisodes: Int, explicitContent: Bool, latestEpisodeID: String, latestPubDateMS: Date?, earliestPubDateMS: Date?, updateFrequencyHours: Int, listenScoreGlobalRank: String) {
        self.id = id
        self.email = email
        self.image = image
        self.title = title
        self.country = country
        self.website = website
        self.language = language
        self.genreIDS = genreIDS
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
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.title = try container.decode(String.self, forKey: .title)
        self.country = try container.decode(String.self, forKey: .country)
        self.website = try container.decodeIfPresent(URL.self, forKey: .website)
        self.language = try container.decode(String.self, forKey: .language)
        self.genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.thumbnail = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.listenScore = Int(try container.decode(String.self, forKey: .listenScore)) ?? .zero
        self.totalEpisodes = try container.decode(Int.self, forKey: .totalEpisodes)
        self.explicitContent = try container.decode(Bool.self, forKey: .explicitContent)
        self.latestEpisodeID = try container.decode(String.self, forKey: .latestEpisodeID)
        self.latestPubDateMS = try container.decodeIfPresent(Date.self, forKey: .latestPubDateMS)
        self.earliestPubDateMS = try container.decodeIfPresent(Date.self, forKey: .earliestPubDateMS)
        self.updateFrequencyHours = try container.decode(Int.self, forKey: .updateFrequencyHours)
        self.listenScoreGlobalRank = try container.decode(String.self, forKey: .listenScoreGlobalRank)
    }

}
