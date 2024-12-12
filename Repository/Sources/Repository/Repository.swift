// The Swift Programming Language
// https://docs.swift.org/swift-book

import Storage
import Combine
import Foundation
import PodcastIndexKit

public protocol DataRepository {
    func popular() async throws -> [PodcastViewModel]
    func search(query: String) async throws -> [PodcastViewModel]
    func download(episode: EpisodeViewModel) async throws
    func popular(completionHandler: @escaping @Sendable (Result<[PodcastViewModel], Error>) -> Void)
    func search(query: String,
                completionHandler: @escaping @Sendable (Result<[PodcastViewModel], Error>) -> Void)
    func download(episode: EpisodeViewModel,
                  completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void)
    func popularPublisher() -> AnyPublisher<[PodcastViewModel], Error>
    func searchPublisher(query: String) -> AnyPublisher<[PodcastViewModel], Error>
    func downloadPublisher(episode: EpisodeViewModel) -> AnyPublisher<Void, Error>
}

internal extension PodcastViewModel {
    init(from webObject: Podcast, withEpisodes episodes: [Episode]) {
        self.init(id: Int64(webObject.id ?? .zero),
                  title: webObject.title,
                  image: URL(string: webObject.image ?? ""),
                  podcastDescription: webObject.podcastDescription,
                  episodes: episodes.map { .init(from: $0) }
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
    public func popular() async throws -> [PodcastViewModel] {
        let webObjects = try await network.trendingPodcasts()
        return try await mapToStorage(webObjects: webObjects)
    }

    public func search(query: String) async throws -> [PodcastViewModel] {
        let webObjects = try await network
            .search(byTerm: query)
        return try await embedEpisodes(inPodcasts: webObjects)
    }

    public func download(episode: EpisodeViewModel) async throws {
        try await storage.download(episode: episode, session: URLSession.shared)
    }

    private func embedEpisodes(inPodcasts podcasts: [Podcast]) async throws -> [PodcastViewModel] {
        return try await withThrowingTaskGroup(of: PodcastViewModel.self, returning: [PodcastViewModel].self) { group in
            for podcast in podcasts {
                group.addTask {
                    guard let feed = podcast.url else {
                        return PodcastViewModel(from: podcast, withEpisodes: [])
                    }
                    let episodes = try await self.network
                        .episodes(byFeedURL: feed)
                    return PodcastViewModel(from: podcast, withEpisodes: episodes)
                }
            }

            var podcasts = [PodcastViewModel]()
            for try await podcast in group {
                podcasts.append(podcast)
            }
            return podcasts
        }
    }

    private func mapToStorage(webObjects: [Podcast]) async throws -> [PodcastViewModel] {
        let results = try await embedEpisodes(inPodcasts: webObjects)
        try await storage.create(results)
        for result in results {
            try await storage.create(result.episodes, forPodcast: result)
        }
        return try storage.read()
    }
}

// MARK: - Closure Methods
public extension Repository {
    
    func popular(completionHandler: @escaping @Sendable (Result<[PodcastViewModel], any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let podcasts = try await self.popular()
                completionHandler(.success(podcasts))
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
    func popularPublisher() -> AnyPublisher<[PodcastViewModel], any Error> {
        return Future<[PodcastViewModel], any Error> { [weak self] promise in
            guard let self else { return }
            let wrapper = FutureResultWrapper(promise)
            self.popular(completionHandler: { result in
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
