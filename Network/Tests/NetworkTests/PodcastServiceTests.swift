import Testing
import Foundation
import Combine
@testable import Network

extension Tag {
    enum PodcastServiceTestTag {}
}

extension Tag.PodcastServiceTestTag {
    @Tag static var async: Tag
    @Tag static var combine: Tag
    @Tag static var closure: Tag
    @Tag static var popular: Tag
    @Tag static var recommended: Tag
    @Tag static var search: Tag
}

@Suite("PodcastService Tests")
final class PodcastServiceTests {

    private let session: MockNetworkURLSession
    private let subject: PodcastService
    private var cancellables: Set<AnyCancellable>

    init() {
        cancellables = Set<AnyCancellable>()
        session = MockNetworkURLSession()
        subject = DefaultPodcastService(session: session, apiKey: TestData.apiKey)
    }

}

// MARK: - Async/Await Methods
extension PodcastServiceTests {
    @Test("Test async popular podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.popular))
    func asyncPopularPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await subject.popular(page: 1)
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test async popular podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.popular))
    func asyncPopularPostcastsFailsWhenDecodingFails() async throws {
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

    @Test("Test async popular podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.popular))
    func asyncPopularPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
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

    @Test("Test async popular podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.popular))
    func asyncPopularPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            let popularPodcasts = try await subject.popular(page: 1)
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test async recommended podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.recommended))
    func asyncRecommendedPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await subject.recommended(basedOn: TestData.podcast, page: 1)
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test async recommended podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.recommended))
    func asyncRecommendedPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            _ = try await subject.recommended(basedOn: TestData.podcast, page: 1)
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

    @Test("Test async recommended podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.recommended))
    func asyncRecommendedPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedRecommendedResponse
        do {
            _ = try await subject.recommended(basedOn: TestData.podcast, page: 1)
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

    @Test("Test async recommended podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.recommended))
    func asyncRecommendedPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            let popularPodcasts = try await subject.recommended(basedOn: TestData.podcast, page: 1)
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test async search podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.search))
    func asyncSearchPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await subject.search(query: TestData.searchQuery, page: 1)
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test async search podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.search))
    func asyncSearchPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = nil
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            _ = try await subject.search(query: TestData.searchQuery, page: 1)
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

    @Test("Test async search podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.search))
    func asyncSearchPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedSearchResponse
        do {
            _ = try await subject.search(query: TestData.searchQuery, page: 1)
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

    @Test("Test async search podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.async, Tag.PodcastServiceTestTag.search))
    func asyncSearchPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validSearchData
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            let popularPodcasts = try await subject.search(query: TestData.searchQuery, page: 1)
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }
}

// MARK: - Closure Methods
extension PodcastServiceTests {
    @Test("Test closure popular podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.popular))
    func closurePopularPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.popular(page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test closure popular podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.popular))
    func closurePopularPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.popular(page: 1) { result in
                    continuation.resume(with: result)
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

    @Test("Test closure popular podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.popular))
    func closurePopularPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedPopularResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.popular(page: 1) { result in
                    continuation.resume(with: result)
                }
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

    @Test("Test closure popular podcasts fails when response code is success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.popular))
    func closurePopularPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject.popular(page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test closure recommended podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.recommended))
    func closureRecommendedPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.recommended(basedOn: TestData.podcast, page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test closure recommended podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.recommended))
    func closureRecommendedPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.recommended(basedOn: TestData.podcast, page: 1) { result in
                    continuation.resume(with: result)
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

    @Test("Test closure recommended podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.recommended))
    func closureRecommendedPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedRecommendedResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.recommended(basedOn: TestData.podcast, page: 1) { result in
                    continuation.resume(with: result)
                }
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

    @Test("Test closure recommended podcasts fails when response code is success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.recommended))
    func closureRecommendedPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject.recommended(basedOn: TestData.podcast, page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test closure search podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.search))
    func closureSearchPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.search(query: TestData.searchQuery, page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test closure search podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.search))
    func closureSearchPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidSearchData
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.search(query: TestData.searchQuery, page: 1) { result in
                    continuation.resume(with: result)
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

    @Test("Test closure search podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.search))
    func closureSearchPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedSearchResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject.search(query: TestData.searchQuery, page: 1) { result in
                    continuation.resume(with: result)
                }
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

    @Test("Test closure search podcasts fails when response code is success",
          .tags(Tag.PodcastServiceTestTag.closure, Tag.PodcastServiceTestTag.search))
    func closureSearchPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validSearchData
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject.search(query: TestData.searchQuery, page: 1) { result in
                    continuation.resume(with: result)
                }
            }
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

}

// MARK: - Combine Publisher Methods
extension PodcastServiceTests {
    @Test("Test combine popular podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.popular))
    func combinePopularPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .popularPublisher(page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test combine popular podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.popular))
    func combinePopularPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .popularPublisher(page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine popular podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.popular))
    func combinePopularPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedPopularResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .popularPublisher(page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine popular podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.popular))
    func combinePopularPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validPopularData
        session.responseToReceive = TestData.successfulPopularResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject
                    .popularPublisher(page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test combine recommended podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.recommended))
    func combineRecommendedPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .recommendedPublisher(basedOn: TestData.podcast, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test combine recommended podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.recommended))
    func combineRecommendedPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .recommendedPublisher(basedOn: TestData.podcast, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine recommended podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.recommended))
    func combineRecommendedPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedRecommendedResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .recommendedPublisher(basedOn: TestData.podcast, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine recommended podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.recommended))
    func combineRecommendedPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validRecommendedData
        session.responseToReceive = TestData.successfulRecommendedResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject
                    .recommendedPublisher(basedOn: TestData.podcast, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
            #expect(popularPodcasts.first == TestData.podcast)
        } catch {
            Issue.record(error, "Test shouldn't throw error")
        }
    }

    @Test("Test combine search podcasts fails when network request throws",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.search))
    func combineSearchPostcastsFailsWhenNetworkRequestThrows() async throws {
        session.errorToThrow = URLError(.unknown)
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .searchPublisher(query: TestData.searchQuery, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Request should fail")
        } catch let error as URLError {
            #expect(error.code == .unknown)
        }
    }

    @Test("Test combine search podcasts fails when decoding fails",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.search))
    func combineSearchPostcastsFailsWhenDecodingFails() async throws {
        session.dataToReceive = TestData.invalidSearchData
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .searchPublisher(query: TestData.searchQuery, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine search podcasts fails when response code is not success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.search))
    func combineSearchPostcastsFailsWhenResponseCodeIsNotSuccess() async throws {
        session.dataToReceive = Data()
        session.responseToReceive = TestData.failedSearchResponse
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                subject
                    .searchPublisher(query: TestData.searchQuery, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
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

    @Test("Test combine search podcasts succeeds when data is valid and response is success",
          .tags(Tag.PodcastServiceTestTag.combine, Tag.PodcastServiceTestTag.search))
    func combineSearchPodcastsSucceedsWhenDataIsValidAndResponseIsSuccess() async throws {
        session.dataToReceive = TestData.validSearchData
        session.responseToReceive = TestData.successfulSearchResponse
        do {
            let popularPodcasts = try await withCheckedThrowingContinuation { continuation in
                subject
                    .searchPublisher(query: TestData.searchQuery, page: 1)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { podcasts in
                        continuation.resume(returning: podcasts)
                    })
                    .store(in: &cancellables)
            }
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
            website: URL(string: "https://example.com")!,
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
        static let invalidPopularData: Data? = nil
        static let validPopularData = {
            let response = PopularPodcastsResponse(podcasts: [podcast])
            return try! JSONEncoder().encode(response)
        }()

        // MARK: - Recommended
        static let successfulRecommendedResponse = HTTPURLResponse(
            url: PodcastAPI.recommended(basedOn: podcast, page: 1, apiKey: apiKey).request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let failedRecommendedResponse = HTTPURLResponse(
            url: PodcastAPI.recommended(basedOn: podcast, page: 1, apiKey: apiKey).request.url!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        static let invalidRecommendedData: Data? = nil
        static let validRecommendedData = {
            let response = PodcastRecommendationsResponse(recommendations: [podcast])
            return try! JSONEncoder().encode(response)
        }()

        // MARK: - Search
        static let searchQuery = "test query"
        static let successfulSearchResponse = HTTPURLResponse(
            url: PodcastAPI.search(query: searchQuery, page: 1, apiKey: apiKey).request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let failedSearchResponse = HTTPURLResponse(
            url: PodcastAPI.search(query: searchQuery, page: 1, apiKey: apiKey).request.url!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        static let invalidSearchData: Data? = nil
        static let validSearchData = {
            let response = PodcastSearchResponse(results: [podcast])
            return try! JSONEncoder().encode(response)
        }()

    }
}
