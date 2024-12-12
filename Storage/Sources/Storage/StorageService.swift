//
//  StorageProtocol.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//
import Combine
import Foundation

/// A protocol defining storage operations for podcasts and episodes.
public protocol StorageService: Sendable {

    /// Reads podcasts from storage that match the specified predicate and sort descriptors.
    /// - Returns: An array of `PodcastViewModel` objects matching the criteria.
    /// - Throws: An error if the read operation fails.
    func read() throws -> [PodcastViewModel]

    /// Asynchronously creates or updates the specified podcasts in storage.
    /// - Parameter podcasts: An array of `PodcastViewModel` objects to store.
    /// - Throws: An error if the operation fails.
    func create(_ podcasts: [PodcastViewModel]) async throws

    /// Asynchronously creates or updates the specified episodes and associates them with a given podcast.
    /// - Parameters:
    ///   - episodes: An array of `EpisodeViewModel` objects to store.
    ///   - podcast: The `PodcastViewModel` object to associate with the episodes.
    /// - Throws: An error if the operation fails.
    func create(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) async throws

    /// Asynchronously deletes the specified podcasts from storage.
    /// - Parameter podcasts: An array of `PodcastViewModel` objects to delete.
    /// - Throws: An error if the operation fails.
    func delete(_ podcasts: [PodcastViewModel]) async throws

    /// Asynchronously deletes the specified episodes from storage.
    /// - Parameter episodes: An array of `EpisodeViewModel` objects to delete.
    /// - Throws: An error if the operation fails.
    func delete(_ episodes: [EpisodeViewModel]) async throws

    /// Asynchronously downloads the content for a specific episode.
    /// - Parameters:
    ///   - episode: The `EpisodeViewModel` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    /// - Throws: An error if the download or storage operation fails.
    func download(episode: EpisodeViewModel, session: NetworkURLSession) async throws

    /// Creates or updates the specified podcasts in storage using a completion handler for result handling.
    /// - Parameters:
    ///   - podcasts: An array of `PodcastViewModel` objects to store.
    ///   - completion: A closure that is called with the result of the operation.
    func create(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, Error>) -> Void)

    /// Creates or updates the specified episodes and associates them with a given podcast using a completion handler.
    /// - Parameters:
    ///   - episodes: An array of `EpisodeViewModel` objects to store.
    ///   - podcast: The `PodcastViewModel` object to associate with the episodes.
    ///   - completion: A closure that is called with the result of the operation.
    func create(_ episodes: [EpisodeViewModel], forPodcast podcast:PodcastViewModel, completion: @escaping (Result<Void, Error>) -> Void)

    /// Deletes the specified podcasts from storage using a completion handler.
    /// - Parameters:
    ///   - podcasts: An array of `PodcastViewModel` objects to delete.
    ///   - completion: A closure that is called with the result of the operation.
    func delete(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, Error>) -> Void)

    /// Deletes the specified episodes from storage using a completion handler.
    /// - Parameters:
    ///   - episodes: An array of `EpisodeViewModel` objects to delete.
    ///   - completion: A closure that is called with the result of the operation.
    func delete(_ episodes: [EpisodeViewModel], completion: @escaping (Result<Void, Error>) -> Void)

    /// Downloads the content for a specific episode using a completion handler.
    /// - Parameters:
    ///   - episode: The `EpisodeViewModel` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    ///   - completion: A closure that is called with the result of the operation.
    func download(episode: EpisodeViewModel, session: NetworkURLSession, completion: @escaping @Sendable (Result<Void, Error>) -> Void)

    /// Creates or updates the specified podcasts in storage and returns a Combine publisher.
    /// - Parameter podcasts: An array of `PodcastViewModel` objects to store.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func createPublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, Error>

    /// Creates or updates the specified episodes and associates them with a given podcast via a Combine publisher.
    /// - Parameters:
    ///   - episodes: An array of `EpisodeViewModel` objects to store.
    ///   - podcast: The `PodcastViewModel` object to associate with the episodes.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func createPublisher(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) -> AnyPublisher<Void, Error>

    /// Deletes the specified podcasts from storage and returns a Combine publisher.
    /// - Parameter podcasts: An array of `PodcastViewModel` objects to delete.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func deletePublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, Error>

    /// Deletes the specified episodes from storage and returns a Combine publisher.
    /// - Parameter episodes: An array of `EpisodeViewModel` objects to delete.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func deletePublisher(_ episodes: [EpisodeViewModel]) -> AnyPublisher<Void, Error>

    /// Downloads the content for a specific episode and marks it as available offline using a Combine publisher.
    /// - Parameters:
    ///   - episode: The `EpisodeViewModel` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func downloadPublisher(episode: EpisodeViewModel, session: NetworkURLSession) -> AnyPublisher<Void, Error>
}
