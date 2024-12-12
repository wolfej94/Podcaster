//
//  Episode.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//


import Foundation
import CoreData

public struct EpisodeViewModel: WebObject {

    public var id: Int64
    public let title: String?
    public let audioLengthSEC: Int32
    public let explicitContent: Bool
    public let guid: String?
    public let datePublished: Date?
    public let episodeNumber: Int32
    public let enclosedURL: URL?
    public let season: Int32
    public let image: URL?
    public let availableOffline: Bool

    internal init(from episode: EpisodeStorageObject) {
        id = episode.id
        title = episode.title
        audioLengthSEC = episode.audioLengthSEC
        explicitContent = episode.explicitContent
        guid = episode.guid
        datePublished = episode.datePublished
        episodeNumber = episode.episodeNumber
        enclosedURL = episode.enclosedURL
        season = episode.season
        image = episode.image
        availableOffline = episode.availableOffline
    }

    public init(id: Int64, title: String?, audioLengthSEC: Int32, explicitContent: Bool, guid: String?, datePublished: Date?, episodeNumber: Int32, enclosedURL: URL?, season: Int32, image: URL?) {
        self.id = id
        self.title = title
        self.audioLengthSEC = audioLengthSEC
        self.explicitContent = explicitContent
        self.guid = guid
        self.datePublished = datePublished
        self.episodeNumber = episodeNumber
        self.enclosedURL = enclosedURL
        self.season = season
        self.image = image
        self.availableOffline = false
    }

}

