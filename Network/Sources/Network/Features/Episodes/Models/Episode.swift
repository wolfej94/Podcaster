//
//  Episode.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

public struct Episode: Codable {
    let id: String
    let audio: String
    let image: String
    let title: String
    let thumbnail: String
    let description: String
    let pubDateMS: Int
    let audioLengthSEC: Int
    let explicitContent: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case audio
        case image
        case title
        case thumbnail
        case description
        case pubDateMS = "pub_date_ms"
        case audioLengthSEC = "audio_length_sec"
        case explicitContent = "explicit_content"
    }
}
