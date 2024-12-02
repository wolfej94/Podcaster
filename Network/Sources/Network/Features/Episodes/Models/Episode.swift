//
//  Episode.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation

public struct Episode: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    let audio: URL
    let image: URL
    let title: String
    let thumbnail: URL
    let summary: String
    let pubDateMS: Date
    let audioLengthSEC: Int
    let explicitContent: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case audio
        case image
        case title
        case thumbnail
        case summary = "description"
        case pubDateMS = "pub_date_ms"
        case audioLengthSEC = "audio_length_sec"
        case explicitContent = "explicit_content"
    }
}
