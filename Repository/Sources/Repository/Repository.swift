// The Swift Programming Language
// https://docs.swift.org/swift-book

import Storage
import Combine
import Foundation
import PodcastIndexKit

public protocol DataRepository {
    func popular(ignoreCache: Bool) async throws -> [PodcastViewModel]
    func episodes(forPodcast podcast: PodcastViewModel, ignoreCache: Bool) async throws -> [EpisodeViewModel]
    func search(query: String) async throws -> [PodcastViewModel]
    func download(episode: EpisodeViewModel) async throws
    func popular(ignoreCache: Bool,
                 completionHandler: @escaping @Sendable (Result<[PodcastViewModel], Error>) -> Void)
    func episodes(forPodcast podcast: PodcastViewModel,
                  ignoreCache: Bool,
                  completionHandler: @escaping @Sendable (Result<[EpisodeViewModel], Error>) -> Void)
    func search(query: String,
                completionHandler: @escaping @Sendable (Result<[PodcastViewModel], Error>) -> Void)
    func download(episode: EpisodeViewModel,
                  completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void)
    func popularPublisher(ignoreCache: Bool) -> AnyPublisher<[PodcastViewModel], Error>
    func episodesPublisher(forPodcast podcast: PodcastViewModel,
                           ignoreCache: Bool) -> AnyPublisher<[EpisodeViewModel], Error>
    func searchPublisher(query: String) -> AnyPublisher<[PodcastViewModel], Error>
    func downloadPublisher(episode: EpisodeViewModel) -> AnyPublisher<Void, Error>
}

internal extension PodcastViewModel {
    init(from webObject: Podcast) {
        self.init(id: Int64(webObject.id ?? .zero),
                  title: webObject.title,
                  image: URL(string: webObject.image ?? ""),
                  podcastDescription: webObject.podcastDescription,
                  feed: webObject.url
        )
    }
}

internal extension EpisodeViewModel {
    init(from webObject: Episode) {
        self.init(id: Int64(webObject.id ?? .zero),
                  title: webObject.title,
                  audioLengthSEC: Int32(webObject.duration ?? .zero),
                  explicitContent: webObject.explicit == .explicit,
                  guid: webObject.guid,
                  datePublished: webObject.datePublished,
                  episodeNumber: Int32(webObject.episode ?? .zero),
                  enclosedURL: URL(string: webObject.enclosureUrl ?? ""),
                  season: Int32(webObject.season ?? .zero),
                  image: URL(string: webObject.image ?? "")
        )
    }
}

public final class Repository: DataRepository, @unchecked Sendable {

    private let storage: StorageService
    private let network: NetworkService

    public init(apiKey: String, secret: String, userAgent: String) {
        self.storage = DefaultStorageService()
        self.network = DefaultNetworkService(apiKey: apiKey, secret: secret, userAgent: userAgent)
    }

    internal init(network: NetworkService, storage: StorageService) {
        self.network = network
        self.storage = storage
    }

}

// MARK: - Async/Await Methods
extension Repository {
    public func popular(ignoreCache: Bool) async throws -> [PodcastViewModel] {
        if ignoreCache {
            let webObjects = try await network.trendingPodcasts()
            return try await mapToStorage(webObjects: webObjects)
        } else {
            return try storage.read()
        }
    }

    public func episodes(forPodcast podcast: PodcastViewModel, ignoreCache: Bool) async throws -> [EpisodeViewModel] {
        if ignoreCache {
            guard let feed = podcast.feed else { return [] }
            let episodes = try await self.network
                .episodes(byFeedURL: feed)
            return try await mapToStorage(webObjects: episodes, forPodcast: podcast)
        } else {
            return try storage.read(forPodcastWithID: podcast.id)
        }
    }

    public func search(query: String) async throws -> [PodcastViewModel] {
        try await network
            .search(byTerm: query)
            .map { PodcastViewModel(from: $0) }
    }

    public func download(episode: EpisodeViewModel) async throws {
        try await storage.download(episode: episode, session: URLSession.shared)
    }

    private func mapToStorage(webObjects: [Podcast]) async throws -> [PodcastViewModel] {
        let results = webObjects.map { PodcastViewModel(from: $0) }
        try await storage.create(results)
        return try storage.read()
    }

    private func mapToStorage(webObjects: [Episode], forPodcast podcast: PodcastViewModel) async throws -> [EpisodeViewModel] {
        let result = webObjects.map { EpisodeViewModel(from: $0) }
        try await storage.create(result, forPodcast: podcast)
        return try storage.read(forPodcastWithID: podcast.id)
    }
}

// MARK: - Closure Methods
public extension Repository {
    
    func popular(ignoreCache: Bool, completionHandler: @escaping @Sendable (Result<[PodcastViewModel], any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let podcasts = try await self.popular(ignoreCache: ignoreCache)
                completionHandler(.success(podcasts))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    func episodes(forPodcast podcast: PodcastViewModel,
                  ignoreCache: Bool,
                  completionHandler: @escaping @Sendable (Result<[EpisodeViewModel], any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let episodes = try await self.episodes(forPodcast: podcast, ignoreCache: ignoreCache)
                completionHandler(.success(episodes))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    func search(query: String, completionHandler: @escaping @Sendable (Result<[PodcastViewModel], any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await completionHandler(.success(search(query: query)))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    func download(episode: EpisodeViewModel, completionHandler: @escaping @Sendable (Result<Void, any Error>) -> Void) {
        let wrapper = FutureResultWrapper(completionHandler)
        Task { [weak self] in
            guard let self else { return }
            do {
                try await wrapper.completionResult(.success(self.download(episode: episode)))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}

// MARK: - Combine Publisher Methods
public extension Repository {
    func popularPublisher(ignoreCache: Bool) -> AnyPublisher<[PodcastViewModel], any Error> {
        return Future<[PodcastViewModel], any Error> { [weak self] promise in
            guard let self else { return }
            let wrapper = FutureResultWrapper(promise)
            self.popular(ignoreCache: ignoreCache, completionHandler: { result in
                Task.detached {
                    wrapper.completionResult(result)
                }
            })
        }
        .eraseToAnyPublisher()
    }

    func episodesPublisher(forPodcast podcast: PodcastViewModel, ignoreCache: Bool) -> AnyPublisher<[EpisodeViewModel], any Error> {
        return Future<[EpisodeViewModel], any Error> { [weak self] promise in
            guard let self else { return }
            let wrapper = FutureResultWrapper(promise)
            self.episodes(forPodcast: podcast, ignoreCache: ignoreCache, completionHandler: { result in
                Task.detached {
                    wrapper.completionResult(result)
                }
            })
        }
        .eraseToAnyPublisher()
    }

    func searchPublisher(query: String) -> AnyPublisher<[PodcastViewModel], any Error> {
        return Future<[PodcastViewModel], any Error> { [weak self] promise in
            guard let self else { return }
            let wrapper = FutureResultWrapper(promise)
            self.search(query: query, completionHandler: { result in
                Task.detached {
                    wrapper.completionResult(result)
                }
            })
        }
        .eraseToAnyPublisher()
    }

    func downloadPublisher(episode: EpisodeViewModel) -> AnyPublisher<Void, any Error> {
        return Future<Void, any Error> { [weak self] promise in
            guard let self else { return }
            let wrapper = FutureResultWrapper(promise)
            self.download(episode: episode, completionHandler: { result in
                Task.detached {
                    wrapper.completionResult(result)
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
