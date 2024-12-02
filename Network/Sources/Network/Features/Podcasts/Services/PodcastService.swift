//
//  PodcastService.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

import Combine
import Foundation

/// Protocol defining a podcast service with multiple methods for fetching podcast data.
protocol PodcastService {

    // MARK: - Async/Await Methods

    /// Fetches a paginated list of popular podcasts asynchronously.
    /// - Parameter page: The page number for paginated results.
    /// - Returns: An array of `Podcast` objects.
    /// - Throws: An error if the request fails.
    func popular(page: Int) async throws -> [Podcast]

    /// Fetches a paginated list of podcasts recommended based on a specific podcast asynchronously.
    /// - Parameters:
    ///   - basedOn: The `Podcast` to base recommendations on.
    ///   - page: The page number for paginated results.
    /// - Returns: An array of `Podcast` objects.
    /// - Throws: An error if the request fails.
    func recommended(basedOn: Podcast, page: Int) async throws -> [Podcast]

    /// Searches for podcasts asynchronously based on a query string, with pagination.
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page number for paginated results.
    /// - Returns: An array of `Podcast` objects matching the query.
    /// - Throws: An error if the request fails.
    func search(query: String, page: Int) async throws -> [Podcast]

    // MARK: - Completion Handler Methods

    /// Fetches a paginated list of popular podcasts using a completion handler.
    /// - Parameters:
    ///   - page: The page number for paginated results.
    ///   - completionHandler: A closure that returns a `Result` containing either an array of `Podcast` objects or an error.
    func popular(
        page: Int,
        completionHandler: @escaping @Sendable (Result<[Podcast], Error>) -> Void
    )

    /// Fetches a paginated list of podcasts recommended based on a specific podcast using a completion handler.
    /// - Parameters:
    ///   - basedOn: The `Podcast` to base recommendations on.
    ///   - page: The page number for paginated results.
    ///   - completionHandler: A closure that returns a `Result` containing either an array of `Podcast` objects or an error.
    func recommended(
        basedOn: Podcast,
        page: Int,
        completionHandler: @escaping @Sendable (Result<[Podcast], Error>) -> Void
    )

    /// Searches for podcasts based on a query string using a completion handler, with pagination.
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page number for paginated results.
    ///   - completionHandler: A closure that returns a `Result` containing either an array of `Podcast` objects or an error.
    func search(
        query: String,
        page: Int,
        completionHandler: @escaping @Sendable (Result<[Podcast], Error>) -> Void
    )

    // MARK: - Combine Publisher Methods

    /// Fetches a paginated list of popular podcasts as a Combine publisher.
    /// - Parameter page: The page number for paginated results.
    /// - Returns: A publisher emitting an array of `Podcast` objects or an error.
    func popularPublisher(page: Int) -> AnyPublisher<[Podcast], Error>

    /// Fetches a paginated list of podcasts recommended based on a specific podcast as a Combine publisher.
    /// - Parameters:
    ///   - basedOn: The `Podcast` to base recommendations on.
    ///   - page: The page number for paginated results.
    /// - Returns: A publisher emitting an array of `Podcast` objects or an error.
    func recommendedPublisher(basedOn: Podcast, page: Int) -> AnyPublisher<[Podcast], Error>

    /// Searches for podcasts based on a query string as a Combine publisher, with pagination.
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page number for paginated results.
    /// - Returns: A publisher emitting an array of `Podcast` objects or an error.
    func searchPublisher(query: String, page: Int) -> AnyPublisher<[Podcast], Error>
}

public final class DefaultPodcastService: Service, PodcastService {

    private let session: NetworkURLSession
    private let apiKey: String

    public init(session: NetworkURLSession = URLSession.shared, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }

}

// MARK: - Async/Await Methods
public extension DefaultPodcastService {

    func popular(page: Int) async throws -> [Podcast] {
        let api: PodcastAPI = .popular(page: page, apiKey: apiKey)
        let response: PopularPodcastsResponse = try await request(api.request, usingSession: session)
        return response.podcasts
    }

    func recommended(basedOn: Podcast, page: Int) async throws -> [Podcast] {
        let api: PodcastAPI = .recommended(basedOn: basedOn, page: page, apiKey: apiKey)
        let response: PodcastRecommendationsResponse = try await request(api.request, usingSession: session)
        return response.recommendations
    }

    func search(query: String, page: Int) async throws -> [Podcast] {
        let api: PodcastAPI = .search(query: query, page: page, apiKey: apiKey)
        let response: PodcastSearchResponse = try await request(api.request, usingSession: session)
        return response.results
    }

}

// MARK: - Closure Methods
public extension DefaultPodcastService {

    func popular(page: Int, completionHandler: @escaping @Sendable (Result<[Podcast], any Error>) -> Void) {
        let api: PodcastAPI = .popular(page: page, apiKey: apiKey)
        request(api.request, usingSession: session) { (result: Result<PopularPodcastsResponse, Error>) in
            completionHandler(result.map(\.podcasts))
        }
    }

    func recommended(basedOn: Podcast, page: Int, completionHandler: @escaping @Sendable (Result<[Podcast], any Error>) -> Void) {
        let api: PodcastAPI = .recommended(basedOn: basedOn, page: page, apiKey: apiKey)
        request(api.request, usingSession: session) { (result: Result<PodcastRecommendationsResponse, Error>) in
            completionHandler(result.map(\.recommendations))
        }
    }

    func search(query: String, page: Int, completionHandler: @escaping @Sendable (Result<[Podcast], any Error>) -> Void) {
        let api: PodcastAPI = .search(query: query, page: page, apiKey: apiKey)
        request(api.request, usingSession: session) { (result: Result<PodcastSearchResponse, Error>) in
            completionHandler(result.map(\.results))
        }
    }

}

// MARK: - Combine Publisher Methods
public extension DefaultPodcastService {

    func popularPublisher(page: Int) -> AnyPublisher<[Podcast], any Error> {
        let api: PodcastAPI = .popular(page: page, apiKey: apiKey)
        let publisher: AnyPublisher<PopularPodcastsResponse, any Error> = request(api.request, usingSession: session)
        return publisher
            .map(\.podcasts)
            .eraseToAnyPublisher()
    }

    func recommendedPublisher(basedOn: Podcast, page: Int) -> AnyPublisher<[Podcast], any Error> {
        let api: PodcastAPI = .recommended(basedOn: basedOn, page: page, apiKey: apiKey)
        let publisher: AnyPublisher<PodcastRecommendationsResponse, any Error> = request(api.request, usingSession: session)
        return publisher
            .map(\.recommendations)
            .eraseToAnyPublisher()
    }

    func searchPublisher(query: String, page: Int) -> AnyPublisher<[Podcast], any Error> {
        let api: PodcastAPI = .search(query: query, page: page, apiKey: apiKey)
        let publisher: AnyPublisher<PodcastSearchResponse, any Error> = request(api.request, usingSession: session)
        return publisher
            .map(\.results)
            .eraseToAnyPublisher()
    }

}
