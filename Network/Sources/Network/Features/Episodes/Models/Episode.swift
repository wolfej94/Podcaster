//
//  Episode.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation

public struct Episode: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    public let audio: URL
    public let image: URL
    public let title: String
    public let thumbnail: URL
    public let summary: String
    public let pubDateMS: Date
    public let audioLengthSEC: Int
    public let explicitContent: Bool

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
