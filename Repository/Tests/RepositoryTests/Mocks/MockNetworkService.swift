//
//  MockNetworkService.swift
//  Repository
//
//  Created by James Wolfe on 11/12/2024.
//

import Repository
import PodcastIndexKit

final class MockNetworkService: NetworkService {

    var trendingPodcastsCalled = false
    var dataToReturnFromTrendingPodcasts = [Podcast]()
    var errorToThrowFromTrendingPodcasts: Error?
    func trendingPodcasts() async throws -> [Podcast] {
        trendingPodcastsCalled = true
        if let errorToThrowFromTrendingPodcasts {
            throw errorToThrowFromTrendingPodcasts
        }
        return dataToReturnFromTrendingPodcasts
    }

    var searchCalled = false
    var dataToReturnFromSearch = [Podcast]()
    var errorToThrowFromSearch: Error?
    func search(byTerm q: String) async throws -> [Podcast] {
        searchCalled = true
        if let errorToThrowFromSearch {
            throw errorToThrowFromSearch
        }
        return dataToReturnFromSearch
    }

    var episodesCalled = false
    var dataToReturnFromEpisodes = [Episode]()
    var errorToThrowFromEpisodes: Error?
    func episodes(byFeedURL url: String) async throws -> [Episode] {
        episodesCalled = true
        if let errorToThrowFromEpisodes {
            throw errorToThrowFromEpisodes
        }
        return dataToReturnFromEpisodes
    }

}
