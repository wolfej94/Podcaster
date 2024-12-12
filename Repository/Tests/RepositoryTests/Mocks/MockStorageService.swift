//
//  MockStorageService.swift
//  Repository
//
//  Created by James Wolfe on 11/12/2024.
//

import Storage
import Combine

final class MockStorageService: StorageService, @unchecked Sendable {

    var readCalled = false
    var errorToThrowFromRead: Error?
    var dataToReturnFromRead = [PodcastViewModel]()
    func read() throws -> [PodcastViewModel] {
        readCalled = true
        if let errorToThrowFromRead { throw errorToThrowFromRead }
        return dataToReturnFromRead
    }

    var createPodcastsCalled = false
    var errorToThrowFromCreatePodcasts: Error?
    func create(_ podcasts: [PodcastViewModel]) async throws {
        createPodcastsCalled = true
        if let errorToThrowFromCreatePodcasts { throw errorToThrowFromCreatePodcasts }
    }

    var createEpisodesCalled = false
    var errorToThrowFromCreateEpisodes: Error?
    func create(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) async throws {
        createEpisodesCalled = true
        if let errorToThrowFromCreateEpisodes { throw errorToThrowFromCreateEpisodes }
    }

    var deletePodcastsCalled = false
    var errorToThrowFromDeletePodcasts: Error?
    func delete(_ podcasts: [PodcastViewModel]) async throws {
        deleteEpisodesCalled = true
        if let errorToThrowFromDeletePodcasts { throw errorToThrowFromDeletePodcasts }
    }

    var deleteEpisodesCalled = false
    var errorToThrowFromDeleteEpisodes: Error?
    func delete(_ episodes: [EpisodeViewModel]) async throws {
        deleteEpisodesCalled = true
        if let errorToThrowFromDeleteEpisodes { throw errorToThrowFromDeleteEpisodes }
    }

    var downloadEpisodeCalled = false
    var errorToThrowFromDownloadEpisode: Error?
    func download(episode: EpisodeViewModel, session: any NetworkURLSession) async throws {
        downloadEpisodeCalled = true
        if let errorToThrowFromDownloadEpisode { throw errorToThrowFromDownloadEpisode }
    }

    func create(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, any Error>) -> Void) {
        createPodcastsCalled = true
        if let errorToThrowFromCreatePodcasts {
            completion(.failure(errorToThrowFromCreatePodcasts))
        } else {
            completion(.success(()))
        }
    }
    
    func create(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        createEpisodesCalled = true
        if let errorToThrowFromCreateEpisodes {
            completion(.failure(errorToThrowFromCreateEpisodes))
        } else {
            completion(.success(()))
        }
    }
    
    func delete(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, any Error>) -> Void) {
        deletePodcastsCalled = true
        if let errorToThrowFromDeletePodcasts {
            completion(.failure(errorToThrowFromDeletePodcasts))
        } else {
            completion(.success(()))
        }
    }
    
    func delete(_ episodes: [EpisodeViewModel], completion: @escaping (Result<Void, any Error>) -> Void) {
        deleteEpisodesCalled = true
        if let errorToThrowFromDeleteEpisodes {
            completion(.failure(errorToThrowFromDeleteEpisodes))
        } else {
            completion(.success(()))
        }
    }
    
    func download(episode: EpisodeViewModel, session: any NetworkURLSession, completion: @escaping @Sendable (Result<Void, any Error>) -> Void) {
        downloadEpisodeCalled = true
        if let errorToThrowFromDownloadEpisode {
            completion(.failure(errorToThrowFromDownloadEpisode))
        } else {
            completion(.success(()))
        }
    }
    
    func createPublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, any Error> {
        createPodcastsCalled = true
        if let errorToThrowFromCreatePodcasts {
            return Fail(error: errorToThrowFromCreatePodcasts)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func createPublisher(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) -> AnyPublisher<Void, any Error> {
        createEpisodesCalled = true
        if let errorToThrowFromCreateEpisodes {
            return Fail(error: errorToThrowFromCreateEpisodes)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func deletePublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, any Error> {
        deletePodcastsCalled = true
        if let errorToThrowFromDeletePodcasts {
            return Fail(error: errorToThrowFromDeletePodcasts)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func deletePublisher(_ episodes: [EpisodeViewModel]) -> AnyPublisher<Void, any Error> {
        deleteEpisodesCalled = true
        if let errorToThrowFromDeleteEpisodes {
            return Fail(error: errorToThrowFromDeleteEpisodes)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func downloadPublisher(episode: EpisodeViewModel, session: any NetworkURLSession) -> AnyPublisher<Void, any Error> {
        downloadEpisodeCalled = true
        if let errorToThrowFromDownloadEpisode {
            return Fail(error: errorToThrowFromDownloadEpisode)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    

}
