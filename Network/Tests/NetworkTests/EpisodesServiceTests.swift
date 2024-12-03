//
//  EpisodesServiceTests.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Testing
import Foundation
import Combine
@testable import Network

extension Tag {
    enum EpisodeServiceTestTag {}
}

extension Tag.EpisodeServiceTestTag {
    @Tag static var async: Tag
    @Tag static var combine: Tag
    @Tag static var closure: Tag
}

@Suite("EpisodesService Tests")
final class EpisodesServiceTests {

    private let session: MockNetworkURLSession
    private let subject: EpisodesService
    private var cancellables: Set<AnyCancellable>

    init() {
        cancellables = Set<AnyCancellable>()
        session = MockNetworkURLSession()
        subject = DefaultEpisodesService(session: session, apiKey: TestData.apiKey)
    }

}

// MARK: - Async/Await Methods
extension EpisodesServiceTests {
    @Test("Test async episodes fails when network request throws",
          .tags(Tag.EpisodeServiceTestTag.async))
    func asyncEpisodesFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await subject.episodes(forPodcast: TestData.podcast)
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test async episode fails when decoding fails",
          .tags(Tag.EpisodeServiceTestTag.async))
    func asyncEpisodesFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            _ = try await subject.episodes(forPodcast: TestData.podcast)
            Issue.record("Request should fail")
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted:
                break
            default:
                Issue.record("Request should throw a corrupted data error")
            }
        }
    }

    @Test("Test async episodes fails when response code is not success",
          .tags(Tag.EpisodeServiceTestTag.async))
    func asyncEpisodesFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedEpisodesResponse
        do {
            _ = try await subject.episodes(forPodcast: TestData.podcast)
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("Test async episodes succeeds when data is valid and response is success",
          .tags(Tag.EpisodeServiceTestTag.async))
    func asyncEpisodesSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            let episodes = try await subject.episodes(forPodcast: TestData.podcast)
            #expect(episodes.first == TestData.episode)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }
}

// MARK: - Closure Methods
extension EpisodesServiceTests {
    @Test("Test closure episodes fails when network request throws",
          .tags(Tag.EpisodeServiceTestTag.closure))
    func closureEpisodesFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodes(forPodcast: TestData.podcast) {
                    continuation.resume(with: $0)
                }
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test closure episode fails when decoding fails",
          .tags(Tag.EpisodeServiceTestTag.closure))
    func closureEpisodesFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodes(forPodcast: TestData.podcast) {
                    continuation.resume(with: $0)
                }
            }
            Issue.record("Request should fail")
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted:
                break
            default:
                Issue.record("Request should throw a corrupted data error")
            }
        }
    }

    @Test("Test closure episodes fails when response code is not success",
          .tags(Tag.EpisodeServiceTestTag.closure))
    func closureEpisodesFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedEpisodesResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodes(forPodcast: TestData.podcast) {
                    continuation.resume(with: $0)
                }
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("Test closure episodes succeeds when data is valid and response is success",
          .tags(Tag.EpisodeServiceTestTag.closure))
    func closureEpisodesSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            let episodes = try await withCheckedThrowingContinuation { continuation in
                subject.episodes(forPodcast: TestData.podcast) {
                    continuation.resume(with: $0)
                }
            }
            #expect(episodes.first == TestData.episode)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }
}

// MARK: - Combine Methods
extension EpisodesServiceTests {
    @Test("Test combine episodes fails when network request throws",
          .tags(Tag.EpisodeServiceTestTag.combine))
    func combineEpisodesFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodesPublisher(forPodcast: TestData.podcast)
                    .sink { result in
                        if case .failure(let error) = result {
                            continuation.resume(throwing: error)
                        }
                    } receiveValue: { episodes in
                        continuation.resume(returning: episodes)
                    }
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test combine episode fails when decoding fails",
          .tags(Tag.EpisodeServiceTestTag.combine))
    func combineEpisodesFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodesPublisher(forPodcast: TestData.podcast)
                    .sink { result in
                        if case .failure(let error) = result {
                            continuation.resume(throwing: error)
                        }
                    } receiveValue: { episodes in
                        continuation.resume(returning: episodes)
                    }
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted:
                break
            default:
                Issue.record("Request should throw a corrupted data error")
            }
        }
    }

    @Test("Test combine episodes fails when response code is not success",
          .tags(Tag.EpisodeServiceTestTag.combine))
    func combineEpisodesFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedEpisodesResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.episodesPublisher(forPodcast: TestData.podcast)
                    .sink { result in
                        if case .failure(let error) = result {
                            continuation.resume(throwing: error)
                        }
                    } receiveValue: { episodes in
                        continuation.resume(returning: episodes)
                    }
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            switch error.code {
            case .badServerResponse:
                break
            default:
                Issue.record("Request should throw a bar server response error")
            }
        }
    }

    @Test("Test combine episodes succeeds when data is valid and response is success",
          .tags(Tag.EpisodeServiceTestTag.combine))
    func combineEpisodesSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validEpisodesData
        session.responseToReceive = TestData.successfulEpisodesResponse
        do {
            let episodes = try await withCheckedThrowingContinuation { continuation in
                subject.episodesPublisher(forPodcast: TestData.podcast)
                    .sink { result in
                        if case .failure(let error) = result {
                            continuation.resume(throwing: error)
                        }
                    } receiveValue: { episodes in
                        continuation.resume(returning: episodes)
                    }
                    .store(in: &cancellables)
            }
            #expect(episodes.first == TestData.episode)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }
}

extension EpisodesServiceTests {
    struct TestData {

        // MARK: - Shared Data
        static let apiKey = "test_api_key"
        static let podcast = Podcast(
            id: "123",
            email: "test@test.test",
            image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
            title: "Title",
            country: "Country",
            website: URL(string: "https://example.com")!,
            language: "ENG",
            genreIDS: [1],
            publisher: "Test Publisher",
            thumbnail: URL(string: "https://picsum.photos/seed/picsum/50/50")!,
            summary: "Test Description",
            listenScore: 10,
            totalEpisodes: 10,
            explicitContent: false,
            latestEpisodeID: "456",
            latestPubDateMS: Date(),
            earliestPubDateMS: Date(),
            updateFrequencyHours: 24,
            listenScoreGlobalRank: "1"
        )
        static let episode = Episode(
            id: "456",
            audio: URL(string: "https://example.com")!,
            image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
            title: "Title",
            thumbnail: URL(string: "https://picsum.photos/seed/picsum/50/50")!,
            summary: "Test Description",
            pubDateMS: Date(),
            audioLengthSEC: 60*60,
            explicitContent: false
        )

        // MARK: - Episodes
        static let successfulEpisodesResponse = HTTPURLResponse(
            url: EpisodeAPI.episodes(podcast: podcast, apiKey: apiKey).request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let failedEpisodesResponse = HTTPURLResponse(
            url: EpisodeAPI.episodes(podcast: podcast, apiKey: apiKey).request.url!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        static let invalidEpisodesData: Data? = nil
        static let validEpisodesData = {
            let response = EpisodesResponse(episodes: [episode])
            return try! JSONEncoder().encode(response)
        }()
    }
}
