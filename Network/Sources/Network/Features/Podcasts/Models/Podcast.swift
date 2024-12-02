//
//  Podcast.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

public struct Podcast: Codable {
    let id: String
    let email: String
    let image: String
    let title: String
    let country: String
    let website: String
    let language: String
    let genreIDS: [Int]
    let publisher: String
    let thumbnail: String
    let description: String
    let listenScore: Int
    let totalEpisodes: Int
    let explicitContent: Bool
    let latestEpisodeID: String
    let latestPubDateMS: Int
    let earliestPubDateMS: Int
    let updateFrequencyHours: Int
    let listenScoreGlobalRank: String

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
        case description
        case listenScore = "listen_score"
        case totalEpisodes = "total_episodes"
        case explicitContent = "explicit_content"
        case latestEpisodeID = "latest_episode_id"
        case latestPubDateMS = "latest_pub_date_ms"
        case earliestPubDateMS = "earliest_pub_date_ms"
        case updateFrequencyHours = "update_frequency_hours"
        case listenScoreGlobalRank = "listen_score_global_rank"
    }
}