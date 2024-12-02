//
//  EpisodesService.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Combine
import Foundation

/// The `EpisodesService` protocol defines the methods for fetching episodes associated with a podcast.
public protocol EpisodesService {

    /// Asynchronous method to fetch episodes for a given podcast.
    /// - Parameter podcast: The `Podcast` object for which to fetch the episodes.
    /// - Returns: An array of `Episode` objects representing the episodes of the provided podcast.
    /// - Throws: An error if the network request fails or the response is invalid.
    func episodes(forPodcast podcast: Podcast) async throws -> [Episode]

    /// Method to fetch episodes for a given podcast using a completion handler.
    /// - Parameter podcast: The `Podcast` object for which to fetch the episodes.
    /// - Parameter completionHandler: A closure to return the result. It contains a `Result` type, which will either be:
    ///   - `.success([Episode])` if the request is successful, or
    ///   - `.failure(Error)` if an error occurs.
    func episodes(forPodcast podcast: Podcast, completionHandler: @escaping @Sendable (Result<[Episode], Error>) -> Void)

    /// Method to fetch episodes for a given podcast using Combine's `AnyPublisher`.
    /// - Parameter podcast: The `Podcast` object for which to fetch the episodes.
    /// - Returns: A `Publisher` that emits either an array of `Episode` objects if successful, or an error if the request fails.
    func episodesPublisher(forPodcast podcast: Podcast) -> AnyPublisher<[Episode], Error>
}

public final class DefaultEpisodesService: Service, EpisodesService {

    private let session: NetworkURLSession
    private let apiKey: String

    public init(session: NetworkURLSession = URLSession.shared, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }
}

// MARK: - Async/Await Methods
public extension DefaultEpisodesService {
    func episodes(forPodcast podcast: Podcast) async throws -> [Episode] {
        let api: EpisodeAPI = .episodes(podcast: podcast, apiKey: apiKey)
        let response: EpisodesResponse = try await request(api.request, usingSession: session)
        return response.episodes
    }
}

// MARK: - Closure Methods
public extension DefaultEpisodesService {
    func episodes(forPodcast podcast: Podcast, completionHandler: @escaping @Sendable (Result<[Episode], any Error>) -> Void) {
        let api: EpisodeAPI = .episodes(podcast: podcast, apiKey: apiKey)
        request(api.request, usingSession: session) { (result: Result<EpisodesResponse, Error>) in
            completionHandler(result.map(\.episodes))
        }
    }
}

// MARK: - Combine Publisher Methods
public extension DefaultEpisodesService {
    func episodesPublisher(forPodcast podcast: Podcast) -> AnyPublisher<[Episode], any Error> {
        let api: EpisodeAPI = .episodes(podcast: podcast, apiKey: apiKey)
        let publisher: AnyPublisher<EpisodesResponse, any Error> = request(api.request, usingSession: session)
        return publisher
            .map(\.episodes)
            .eraseToAnyPublisher()
    }
}
