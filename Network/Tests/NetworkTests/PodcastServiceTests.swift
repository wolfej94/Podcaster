import Testing
import Foundation
@testable import Network

@Suite("PodcastService Tests")
struct PodcastServiceTests {

    let session: MockNetworkURLSession
    let subject: PodcastService

    init() {
        session = MockNetworkURLSession()
        subject = DefaultPodcastService(session: session, apiKey: TestData.apiKey)
    }

    @Test("Test popular podcasts fails when network request throws")
    func popularPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = TestData.Error.generic
        do {
            _ = try await subject.popular(page: 1)
            Issue.record("Request should fail")
        } catch {
            #expect(error.localizedDescription == TestData.Error.generic.localizedDescription)
        }
    }

    @Test("Test popular podcasts fails when decoding fails")
    func popularPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            _ = try await subject.popular(page: 1)
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

    @Test("Test popular podcasts fails when response code is not success")
    func popularPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedPopularResponse
        do {
            _ = try await subject.popular(page: 1)
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

    @Test("Test popular podcasts succeeds when data is valid and response is success")
    func popularPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            let popularPodcasts = try await subject.popular(page: 1)
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }


}

extension PodcastServiceTests {
    struct TestData {

        // MARK: - Shared Data
        static let apiKey = "test_api_key"
        static let podcast = Podcast(
            id: "123",
            email: "test@test.test",
            image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
            title: "Title",
            country: "Country",
            website: URL(string: "https://google.com")!,
            language: "ENG",
            genreIDS: [1],
            publisher: "Test Publisher",
            thumbnail: URL(string: "https://picsum.photos/seed/picsum/50/50")!,
            description: "Test Description",
            listenScore: 10,
            totalEpisodes: 10,
            explicitContent: false,
            latestEpisodeID: "456",
            latestPubDateMS: Date(),
            earliestPubDateMS: Date(),
            updateFrequencyHours: 24,
            listenScoreGlobalRank: "1"
        )

        // MARK: - Popular
        static let successfulPopularResponse = HTTPURLResponse(
            url: PodcastAPI.popular(page: 1, apiKey: apiKey).request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let failedPopularResponse = HTTPURLResponse(
            url: PodcastAPI.popular(page: 1, apiKey: apiKey).request.url!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        static let invalidPopularData = Data()
        static let validPopularData = {
            let response = PopularPodcastsResponse(podcasts: [podcast])
            return try! JSONEncoder().encode(response)
        }()

        // MARK: - Errors
        enum Error: LocalizedError {
            case generic
        }
    }
}
