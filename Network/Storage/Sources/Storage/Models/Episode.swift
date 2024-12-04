//
//  Episode.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//


import Foundation
import CoreData

public struct Episode: StorageObject {

    public let id: String
    public let audio: URL?
    public let image: URL?
    public let title: String
    public let thumbnail: URL?
    public let summary: String
    public let pubDateMS: Date?
    public let audioLengthSEC: Int
    public let explicitContent: Bool
    public let availableOffline: Bool

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

    internal init(from: EpisodeStorageObject) {
        id = from.id ?? ""
        audio = from.audio
        image = from.image
        title = from.title ?? ""
        thumbnail = from.thumbnail
        summary = from.summary ?? ""
        pubDateMS = from.pubDateMS
        audioLengthSEC = Int(from.audioLengthSEC)
        explicitContent = from.explicitContent
        availableOffline = from.availabileOffline
    }

    public init(id: String, audio: URL?, image: URL?, title: String, thumbnail: URL?, summary: String, pubDateMS: Date?, audioLengthSEC: Int, explicitContent: Bool, availableOffline: Bool) {
        self.id = id
        self.audio = audio
        self.image = image
        self.title = title
        self.thumbnail = thumbnail
        self.summary = summary
        self.pubDateMS = pubDateMS
        self.audioLengthSEC = audioLengthSEC
        self.explicitContent = explicitContent
        self.availableOffline = availableOffline
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

