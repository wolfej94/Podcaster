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
    /// - Returns: An array of `Podcast` objects matching the criteria.
    /// - Throws: An error if the read operation fails.
    func read() throws -> [Podcast]

    /// Asynchronously creates or updates the specified podcasts in storage.
    /// - Parameter podcasts: An array of `Podcast` objects to store.
    /// - Throws: An error if the operation fails.
    func create(_ podcasts: [Podcast]) async throws

    /// Asynchronously creates or updates the specified episodes and associates them with a given podcast.
    /// - Parameters:
    ///   - episodes: An array of `Episode` objects to store.
    ///   - podcast: The `Podcast` object to associate with the episodes.
    /// - Throws: An error if the operation fails.
    func create(_ episodes: [Episode], forPodcast podcast: Podcast) async throws

    /// Asynchronously deletes the specified podcasts from storage.
    /// - Parameter podcasts: An array of `Podcast` objects to delete.
    /// - Throws: An error if the operation fails.
    func delete(_ podcasts: [Podcast]) async throws

    /// Asynchronously deletes the specified episodes from storage.
    /// - Parameter episodes: An array of `Episode` objects to delete.
    /// - Throws: An error if the operation fails.
    func delete(_ episodes: [Episode]) async throws

    /// Asynchronously downloads the content for a specific episode.
    /// - Parameters:
    ///   - episode: The `Episode` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    /// - Throws: An error if the download or storage operation fails.
    func download(episode: Episode, session: NetworkURLSession) async throws

    /// Creates or updates the specified podcasts in storage using a completion handler for result handling.
    /// - Parameters:
    ///   - podcasts: An array of `Podcast` objects to store.
    ///   - completion: A closure that is called with the result of the operation.
    func create(_ podcasts: [Podcast], completion: @escaping (Result<Void, Error>) -> Void)

    /// Creates or updates the specified episodes and associates them with a given podcast using a completion handler.
    /// - Parameters:
    ///   - episodes: An array of `Episode` objects to store.
    ///   - podcast: The `Podcast` object to associate with the episodes.
    ///   - completion: A closure that is called with the result of the operation.
    func create(_ episodes: [Episode], forPodcast podcast: Podcast, completion: @escaping (Result<Void, Error>) -> Void)

    /// Deletes the specified podcasts from storage using a completion handler.
    /// - Parameters:
    ///   - podcasts: An array of `Podcast` objects to delete.
    ///   - completion: A closure that is called with the result of the operation.
    func delete(_ podcasts: [Podcast], completion: @escaping (Result<Void, Error>) -> Void)

    /// Deletes the specified episodes from storage using a completion handler.
    /// - Parameters:
    ///   - episodes: An array of `Episode` objects to delete.
    ///   - completion: A closure that is called with the result of the operation.
    func delete(_ episodes: [Episode], completion: @escaping (Result<Void, Error>) -> Void)

    /// Downloads the content for a specific episode using a completion handler.
    /// - Parameters:
    ///   - episode: The `Episode` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    ///   - completion: A closure that is called with the result of the operation.
    func download(episode: Episode, session: NetworkURLSession, completion: @escaping @Sendable (Result<Void, Error>) -> Void)

    /// Creates or updates the specified podcasts in storage and returns a Combine publisher.
    /// - Parameter podcasts: An array of `Podcast` objects to store.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func createPublisher(_ podcasts: [Podcast]) -> AnyPublisher<Void, Error>

    /// Creates or updates the specified episodes and associates them with a given podcast via a Combine publisher.
    /// - Parameters:
    ///   - episodes: An array of `Episode` objects to store.
    ///   - podcast: The `Podcast` object to associate with the episodes.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func createPublisher(_ episodes: [Episode], forPodcast podcast: Podcast) -> AnyPublisher<Void, Error>

    /// Deletes the specified podcasts from storage and returns a Combine publisher.
    /// - Parameter podcasts: An array of `Podcast` objects to delete.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func deletePublisher(_ podcasts: [Podcast]) -> AnyPublisher<Void, Error>

    /// Deletes the specified episodes from storage and returns a Combine publisher.
    /// - Parameter episodes: An array of `Episode` objects to delete.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func deletePublisher(_ episodes: [Episode]) -> AnyPublisher<Void, Error>

    /// Downloads the content for a specific episode and marks it as available offline using a Combine publisher.
    /// - Parameters:
    ///   - episode: The `Episode` object to download.
    ///   - session: The `NetworkURLSession` to use for the download operation.
    /// - Returns: A Combine `AnyPublisher` that publishes success or an error.
    func downloadPublisher(episode: Episode, session: NetworkURLSession) -> AnyPublisher<Void, Error>
}
