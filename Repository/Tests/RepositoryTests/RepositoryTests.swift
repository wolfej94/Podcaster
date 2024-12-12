import Testing
@testable import Repository
@testable import Storage
@testable import PodcastIndexKit
import Foundation
import Combine

@Suite("Repository Tests")
final class RepositoryTests {

    let storage: MockStorageService
    let network: MockNetworkService
    let repository: Repository
    var cancellables = Set<AnyCancellable>()

    init() {
        self.storage = MockStorageService()
        self.network = MockNetworkService()
        self.repository = Repository(network: network, storage: storage)
    }

}

// MARK: - Async/Await Methods
extension RepositoryTests {

    @Test("Test async popular podcasts throws when network fails to fetch trending podcasts")
    func asyncPopularPodcastsThrowsWhenNetworkFailsToFetchTrendingPodcasts() async throws {
        network.errorToThrowFromTrendingPodcasts = TestData.Error.generic
        do {
            _ = try await repository.popular()
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.trendingPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async popular podcasts throws when network fails to fetch episodes")
    func asyncPopularPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await repository.popular()
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async popular podcasts throws when storage fails to create podcast")
    func asyncPopularPodcastsThrowsWhenStorageFailsToCreatePodcast() async throws {
        storage.errorToThrowFromCreatePodcasts = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await repository.popular()
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async popular podcasts throws when storage fails to create episodes")
    func asyncPopularPodcastsThrowsWhenStorageFailsToCreateEpisodes() async throws {
        storage.errorToThrowFromCreateEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await repository.popular()
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createEpisodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async popular podcasts throws when storage fails to read podcasts")
    func asyncPopularPodcastsThrowsWhenStorageFailsToReadPodcasts() async throws {
        storage.errorToThrowFromRead = TestData.Error.generic
        do {
            _ = try await repository.popular()
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.readCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async popular podcasts returns correct data when everything is successful")
    func asyncPopularPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        storage.dataToReturnFromRead = [TestData.podcastViewModel]
        let results = try await repository.popular()
        #expect(results == [TestData.podcastViewModel])
        #expect(network.trendingPodcastsCalled)
    }

    @Test("Test async search podcasts throws when network fails to fetch search results")
    func asyncSearchPodcastsThrowsWhenNetworkFailsToFetchSearchResults() async throws {
        network.errorToThrowFromSearch = TestData.Error.generic
        do {
            _ = try await repository.search(query: TestData.searchTerm)
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.searchCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async create podcasts episodes are empty if podcast url is nil")
    func asyncSearchPodcastsEpisodesAreEmptyIfPodcastURLIsNil() async throws {
        network.dataToReturnFromSearch = [TestData.podcastWithNoURL]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await repository.search(query: TestData.searchTerm)
        #expect(results.first?.episodes.count == .zero)
        #expect(network.searchCalled)
    }

    @Test("Test async create podcasts throws when network fails to fetch episodes")
    func asyncSearchPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromSearch = [TestData.podcast]
        do {
            _ = try await repository.search(query: TestData.searchTerm)
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async search podcasts returns correct data when everything is successful")
    func asyncSearchPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromSearch = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await repository.search(query: TestData.searchTerm)
        #expect(results == [PodcastViewModel(from: TestData.podcast, withEpisodes: [TestData.episode])])
        #expect(network.searchCalled)
    }

    @Test("Test async download episode throws when storage fails to download episode")
    func asyncDownloadEpisodeThrowsWhenNetworkFailsToDownloadEpisode() async throws {
        storage.errorToThrowFromDownloadEpisode = TestData.Error.generic
        do {
            _ = try await repository.download(episode: TestData.episodeViewModel)
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.downloadEpisodeCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test async download episode does not throw when everything is successful")
    func asyncDownloadEpisodeDoesNotThrowWhenEverythingIsSuccessful() async throws {
        try await repository.download(episode: TestData.episodeViewModel)
        #expect(storage.downloadEpisodeCalled)
    }

}

// MARK: - Closure Methods
extension RepositoryTests {

    @Test("Test closure popular podcasts throws when network fails to fetch trending podcasts")
    func closurePopularPodcastsThrowsWhenNetworkFailsToFetchTrendingPodcasts() async throws {
        network.errorToThrowFromTrendingPodcasts = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popular { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.trendingPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure popular podcasts throws when network fails to fetch episodes")
    func closurePopularPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popular { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure popular podcasts throws when storage fails to create podcast")
    func closurePopularPodcastsThrowsWhenStorageFailsToCreatePodcast() async throws {
        storage.errorToThrowFromCreatePodcasts = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popular { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure popular podcasts throws when storage fails to create episodes")
    func closurePopularPodcastsThrowsWhenStorageFailsToCreateEpisodes() async throws {
        storage.errorToThrowFromCreateEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popular { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createEpisodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure popular podcasts throws when storage fails to read podcasts")
    func closurePopularPodcastsThrowsWhenStorageFailsToReadPodcasts() async throws {
        storage.errorToThrowFromRead = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popular { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.readCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure popular podcasts returns correct data when everything is successful")
    func closurePopularPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        storage.dataToReturnFromRead = [TestData.podcastViewModel]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.popular() { continuation.resume(with: $0) }
        }
        #expect(results == [TestData.podcastViewModel])
        #expect(network.trendingPodcastsCalled)
    }

    @Test("Test closure search podcasts throws when network fails to fetch search results")
    func closureSearchPodcastsThrowsWhenNetworkFailsToFetchSearchResults() async throws {
        network.errorToThrowFromSearch = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.search(query: TestData.searchTerm) { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.searchCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure create podcasts episodes are empty if podcast url is nil")
    func closureSearchPodcastsEpisodesAreEmptyIfPodcastURLIsNil() async throws {
        network.dataToReturnFromSearch = [TestData.podcastWithNoURL]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.search(query: TestData.searchTerm) { continuation.resume(with: $0) }
        }
        #expect(results.first?.episodes.count == .zero)
        #expect(network.searchCalled)
    }

    @Test("Test closure create podcasts throws when network fails to fetch episodes")
    func closureSearchPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromSearch = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.search(query: TestData.searchTerm) { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure search podcasts returns correct data when everything is successful")
    func closureSearchPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromSearch = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.search(query: TestData.searchTerm) { continuation.resume(with: $0) }
        }
        #expect(results == [PodcastViewModel(from: TestData.podcast, withEpisodes: [TestData.episode])])
        #expect(network.searchCalled)
    }

    @Test("Test closure download episode throws when network fails to download episode")
    func closureDownloadEpisodeThrowsWhenNetworkFailsToDownloadEpisode() async throws {
        storage.errorToThrowFromDownloadEpisode = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.download(episode: TestData.episodeViewModel) { continuation.resume(with: $0) }
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.downloadEpisodeCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test closure download episode does not throw when everything is successful")
    func closureDownloadEpisodeDoesNotThrowWhenEverythingIsSuccessful() async throws {
        try await withCheckedThrowingContinuation { continuation in
            repository.download(episode: TestData.episodeViewModel) { continuation.resume(with: $0) }
        }
        #expect(storage.downloadEpisodeCalled)
    }

}

// MARK: - Combine Methods
extension RepositoryTests {

    @Test("Test combine popular podcasts throws when network fails to fetch trending podcasts")
    func combinePopularPodcastsThrowsWhenNetworkFailsToFetchTrendingPodcasts() async throws {
        network.errorToThrowFromTrendingPodcasts = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popularPublisher()
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.trendingPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine popular podcasts throws when network fails to fetch episodes")
    func combinePopularPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popularPublisher()
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine popular podcasts throws when storage fails to create podcast")
    func combinePopularPodcastsThrowsWhenStorageFailsToCreatePodcast() async throws {
        storage.errorToThrowFromCreatePodcasts = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popularPublisher()
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createPodcastsCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine popular podcasts throws when storage fails to create episodes")
    func combinePopularPodcastsThrowsWhenStorageFailsToCreateEpisodes() async throws {
        storage.errorToThrowFromCreateEpisodes = TestData.Error.generic
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popularPublisher()
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.createEpisodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine popular podcasts throws when storage fails to read podcasts")
    func combinePopularPodcastsThrowsWhenStorageFailsToReadPodcasts() async throws {
        storage.errorToThrowFromRead = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.popularPublisher()
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.readCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine popular podcasts returns correct data when everything is successful")
    func combinePopularPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromTrendingPodcasts = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        storage.dataToReturnFromRead = [TestData.podcastViewModel]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.popularPublisher()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
                .store(in: &cancellables)
        }
        #expect(results == [TestData.podcastViewModel])
        #expect(network.trendingPodcastsCalled)
    }

    @Test("Test combine search podcasts throws when network fails to fetch search results")
    func combineSearchPodcastsThrowsWhenNetworkFailsToFetchSearchResults() async throws {
        network.errorToThrowFromSearch = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.searchPublisher(query: TestData.searchTerm)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.searchCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine create podcasts episodes are empty if podcast url is nil")
    func combineSearchPodcastsEpisodesAreEmptyIfPodcastURLIsNil() async throws {
        network.dataToReturnFromSearch = [TestData.podcastWithNoURL]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.searchPublisher(query: TestData.searchTerm)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
                .store(in: &cancellables)
        }
        #expect(results.first?.episodes.count == .zero)
        #expect(network.searchCalled)
    }

    @Test("Test combine create podcasts throws when network fails to fetch episodes")
    func combineSearchPodcastsThrowsWhenNetworkFailsToFetchEpisodes() async throws {
        network.errorToThrowFromEpisodes = TestData.Error.generic
        network.dataToReturnFromSearch = [TestData.podcast]
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.searchPublisher(query: TestData.searchTerm).sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
                .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(network.episodesCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine search podcasts returns correct data when everything is successful")
    func combineSearchPodcastsReturnsCorrectDataWhenEverythingIsSuccessful() async throws {
        network.dataToReturnFromSearch = [TestData.podcast]
        network.dataToReturnFromEpisodes = [TestData.episode]
        let results = try await withCheckedThrowingContinuation { continuation in
            repository.searchPublisher(query: TestData.searchTerm)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
                .store(in: &cancellables)
        }
        #expect(results == [PodcastViewModel(from: TestData.podcast, withEpisodes: [TestData.episode])])
        #expect(network.searchCalled)
    }

    @Test("Test combine download episode throws when network fails to download episode")
    func combineDownloadEpisodeThrowsWhenNetworkFailsToDownloadEpisode() async throws {
        storage.errorToThrowFromDownloadEpisode = TestData.Error.generic
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                repository.downloadPublisher(episode: TestData.episodeViewModel)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Error should throw")
        } catch let error as TestData.Error {
            #expect(storage.downloadEpisodeCalled)
            #expect(error == .generic)
        }
    }

    @Test("Test combine download episode does not throw when everything is successful")
    func combineDownloadEpisodeDoesNotThrowWhenEverythingIsSuccessful() async throws {
        try await withCheckedThrowingContinuation { continuation in
            repository.downloadPublisher(episode: TestData.episodeViewModel)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
                .store(in: &cancellables)
        }
        #expect(storage.downloadEpisodeCalled)
    }

}

extension RepositoryTests {
    struct TestData {
        static let episodeViewModel = EpisodeViewModel(
            id: 1,
            title: "Test",
            audioLengthSEC: 60*60,
            explicitContent: false,
            guid: "123",
            datePublished: Date(),
            episodeNumber: 1,
            enclosedURL: URL(string: "https://download.samplelib.com/mp3/sample-3s.mp3")!,
            season: 1,
            image: URL(string: "https://picsum.photos/seed/picsum/200/300")!
        )
        static let episode = Episode(
            id: 1,
            title: "Test",
            link: nil,
            episodeDescription: nil,
            guid: "123",
            datePublished: Date(),
            datePublishedPretty: nil,
            dateCrawled: nil,
            enclosureUrl: "https://download.samplelib.com/mp3/sample-3s.mp3",
            enclosureType: nil,
            enclosureLength: nil,
            contentLink: nil,
            duration: nil,
            explicit: .notExplicit,
            episode: 1,
            episodeType: nil,
            season: 1,
            image: "https://picsum.photos/seed/picsum/200/300",
            feedItunesId: nil,
            feedImage: nil,
            feedId: nil,
            feedLanguage: nil,
            feedDead: nil,
            feedTitle: nil,
            feedDuplicateOf: nil,
            chaptersUrl: nil,
            transcriptUrl: nil,
            feedImageUrlHash: nil,
            imageUrlHash: nil,
            transcripts: nil,
            persons: nil,
            socialInteract: nil,
            value: nil,
            soundbite: nil,
            soundbites: nil,
            startTime: nil,
            endTime: nil,
            status: nil
        )
        static let podcast = Podcast(
            id: 1,
            title: "test",
            url: "https://test.com",
            originalUrl: nil,
            link: nil,
            podcastDescription: "test",
            author: nil,
            ownerName: nil,
            image: "https://picsum.photos/seed/picsum/200/300",
            artwork: "https://picsum.photos/seed/picsum/200/300",
            lastUpdateTime: nil,
            lastCrawlTime: nil,
            lastParseTime: nil,
            lastGoodHttpStatusTime: nil,
            lastHttpStatus: nil,
            contentType: nil,
            itunesId: nil,
            generator: nil,
            language: "EN",
            type: nil,
            dead: nil,
            crawlErrors: nil,
            parseErrors: nil,
            categories: nil,
            locked: nil,
            podcastGuid: nil,
            episodeCount: nil,
            imageUrlHash: nil,
            newestItemPubdate: nil,
            explicit: false,
            itunesType: nil,
            chash: nil,
            value: nil,
            funding: nil)
        static let podcastWithNoURL = Podcast(
            id: 1,
            title: "test",
            url: nil,
            originalUrl: nil,
            link: nil,
            podcastDescription: "test",
            author: nil,
            ownerName: nil,
            image: "https://picsum.photos/seed/picsum/200/300",
            artwork: "https://picsum.photos/seed/picsum/200/300",
            lastUpdateTime: nil,
            lastCrawlTime: nil,
            lastParseTime: nil,
            lastGoodHttpStatusTime: nil,
            lastHttpStatus: nil,
            contentType: nil,
            itunesId: nil,
            generator: nil,
            language: "EN",
            type: nil,
            dead: nil,
            crawlErrors: nil,
            parseErrors: nil,
            categories: nil,
            locked: nil,
            podcastGuid: nil,
            episodeCount: nil,
            imageUrlHash: nil,
            newestItemPubdate: nil,
            explicit: false,
            itunesType: nil,
            chash: nil,
            value: nil,
            funding: nil)
        static let podcastViewModel = PodcastViewModel(from: podcast, withEpisodes: [episode])
        static let searchTerm = "Test"
        enum Error: LocalizedError {
            case generic
        }
    }
}
