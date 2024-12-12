//
//  Network.swift
//  Repository
//
//  Created by James Wolfe on 11/12/2024.
//

import PodcastIndexKit

public protocol NetworkService {
    func trendingPodcasts() async throws -> [Podcast]
    func search(byTerm q: String) async throws -> [Podcast]
    func episodes(byFeedURL url: String) async throws -> [Episode]
}

struct DefaultNetworkService: NetworkService {

    private let podcastService: PodcastsService
    private let searchService: SearchService
    private let episodesService: EpisodesService

    init(apiKey: String, secret: String, userAgent: String) {
        PodcastIndexKit.setup(apiKey: apiKey, apiSecret: secret, userAgent: userAgent)
        let network = PodcastIndexKit()
        podcastService = network.podcastsService
        searchService = network.searchService
        episodesService = network.episodesService
    }

    func trendingPodcasts() async throws -> [Podcast] {
        try await podcastService.trendingPodcasts(lang: "EN").feeds ?? []
    }

    func search(byTerm q: String) async throws -> [Podcast] {
        try await searchService.search(byTerm: q).feeds ?? []
    }

    func episodes(byFeedURL url: String) async throws -> [Episode] {
        try await episodesService.episodes(byFeedURL: url).items ?? []
    }
    
}
