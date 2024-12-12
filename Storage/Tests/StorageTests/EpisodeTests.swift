import Testing
import Foundation
import Combine
import CoreData
@testable import Storage

extension Tag {
    enum EpisodeTestTag {}
}

extension Tag.EpisodeTestTag {
    @Tag static var sync: Tag
    @Tag static var async: Tag
    @Tag static var combine: Tag
    @Tag static var closure: Tag
    @Tag static var create: Tag
    @Tag static var read: Tag
    @Tag static var delete: Tag
    @Tag static var download: Tag
}

@Suite("Episodes Storage Tests")
final class EpisodesTests {

    let mockNetworkSession: MockNetworkURLSession
    let fileManager: DefaultFileManagerHelper
    let mockFileManager: MockFileManagerHelper
    let mockCoreData: MockCoreDataHelper
    let subjectUsingMockHelpers: DefaultStorageService
    let subjectUsingMockNetworkSession: DefaultStorageService
    let context: NSManagedObjectContext
    var cancellables = Set<AnyCancellable>()

    init() {
        self.mockFileManager = MockFileManagerHelper()
        self.mockCoreData = MockCoreDataHelper()
        self.subjectUsingMockHelpers = DefaultStorageService(fileManager: mockFileManager,
                                                             coreData: mockCoreData)

        self.mockNetworkSession = MockNetworkURLSession()
        self.fileManager = DefaultFileManagerHelper()
        self.subjectUsingMockNetworkSession = DefaultStorageService(fileManager: fileManager,
                                                                    coreData: mockCoreData)
        self.context = subjectUsingMockNetworkSession.container.viewContext
    }

}

// MARK: - Synchronous Methods
extension EpisodesTests {
    @Test("Test error throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.sync, Tag.EpisodeTestTag.read)
    )
    func errorThrowsWhenFetchEpisodesFails() throws {
        mockCoreData.errorToThrowForFetchObjects = TestData.Error.generic
        do {
            _ = try subjectUsingMockHelpers.read().first?.episodes
            Issue.record("Fetch should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test data returned when fetch episodes succeeds",
          .tags(Tag.EpisodeTestTag.sync, Tag.EpisodeTestTag.read)
    )
    func dataReturnedThrowWhenFetchEpisodesSucceeds() throws {
        mockCoreData.dataToReturnForFetchObjects = [PodcastStorageObject(podcast: TestData.podcast, context: context)]
        let episodes = try subjectUsingMockHelpers.read().first?.episodes
        #expect(episodes?.first?.id == TestData.episode.id)
    }
}

// MARK: - Async/Await Methods
extension EpisodesTests {

    @Test("Test async create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenBatchInsertFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenFetchPodcastFails() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async create throws when fetch podcast returns nil",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenFetchPodcastReturnsNil() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
            Issue.record("Create should throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Incorrect error thrown")
            }
        }
    }

    @Test("Test async create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenFetchCreatedEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForFetchObjects = TestData.Error.generic
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        mockCoreData.errorToThrowForSaveAndRelateEpisodes = TestData.Error.generic
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        do {
            _ = try await subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast)
        } catch {
            Issue.record("Create should not throw")
        }
    }

    @Test("Test async delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteThrowsWhenDeleteEpisodesFails() async throws {
        mockCoreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await subjectUsingMockHelpers.delete([TestData.episode])
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async delete throws when fetch episode IDs fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteThrowsWhenFetchEpisodeIDsFails() async throws {
        mockCoreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await subjectUsingMockHelpers.delete([TestData.episode])
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await subjectUsingMockHelpers.delete([TestData.episode])
        } catch {
            Issue.record("Delete should not throw")
        }
    }

    @Test("Test async download throws when failing to fetch episode",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenFailingToFetchEpisode() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            try await subjectUsingMockHelpers.download(episode: TestData.episode)
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await subjectUsingMockHelpers.download(episode: TestData.episode)
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncCleanupFilesCalledWhenDownloadEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await subjectUsingMockHelpers.download(episode: TestData.episode)
            Issue.record("Download should not throw")
        } catch {
            #expect(mockFileManager.cleanupFilesCalled)
        }
    }

    @Test("Test async download throws when downloading an episode fails network request",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadingAnEpisodeFailsNetworkRequest() async throws {
        mockNetworkSession.errorToThrow = URLError(.badServerResponse)
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession)
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("Test async download throws when fetching episode fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenFetchingEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            try await subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession)
            Issue.record("Download should not throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Download should throw StorageError.objectNotFound")
            }
        }
    }

    @Test("Test async download succeeds when nothing throws",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadSucceedsWhenNothingThrows() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.dataToReceive = TestData.validDownloadData
        mockNetworkSession.responseToReceive = TestData.successfulDownloadResponse
        do {
            try await subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession)
        } catch {
            Issue.record("Download should not throw")
        }
    }

    @Test("Test async download fails when network response is failure",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenNetworkResponseIsFailure() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.responseToReceive = TestData.failedDownloadResponse
        do {
            try await subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession)
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

}

// MARK: - Closure Methods
extension EpisodesTests {

    @Test("Test closure create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenBatchInsertFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenFetchPodcastFails() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenFetchCreatedEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForFetchObjects = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure create throws when fetch podcast returns nil",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenFetchPodcastReturnsNil() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
            Issue.record("Create should throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Incorrect error thrown")
            }
        }
    }

    @Test("Test closure create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        mockCoreData.errorToThrowForSaveAndRelateEpisodes = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.create([TestData.episode], forPodcast: TestData.podcast) { continuation.resume(with: $0) }
            }
        } catch {
            Issue.record("Create should not throw")
        }
    }

    @Test("Test closure delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteThrowsWhenDeleteEpisodesFails() async throws {
        mockCoreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.delete([TestData.episode]) { continuation.resume(with: $0) }
            }
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure delete throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteThrowsWhenFetchEpisodesFails() async throws {
        mockCoreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.delete([TestData.episode]) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.delete([TestData.episode]) { continuation.resume(with: $0) }
            }
        } catch {
            Issue.record("Delete should not throw")
        }
    }

    @Test("Test closure download throws when failing to fetch episode",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenFailingToFetchEpisode() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.download(episode: TestData.episode) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.download(episode: TestData.episode) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureCleanupFilesCalledWhenDownloadEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.download(episode: TestData.episode) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch {
            #expect(mockFileManager.cleanupFilesCalled)
        }
    }

    @Test("Test closure download throws when downloading an episode fails network request",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadingAnEpisodeFailsNetworkRequest() async throws {
        mockNetworkSession.errorToThrow = URLError(.badServerResponse)
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("Test closure download throws when fetching episode fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenFetchingEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Download should throw StorageError.objectNotFound")
            }
        }
    }

    @Test("Test closure download succeeds when nothing throws",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadSucceedsWhenNothingThrows() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.dataToReceive = TestData.validDownloadData
        mockNetworkSession.responseToReceive = TestData.successfulDownloadResponse
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession) { continuation.resume(with: $0) }
            }
        } catch {
            Issue.record("Download should not throw")
        }
    }

    @Test("Test closure download fails when network response is failure",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenNetworkResponseIsFailure() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.responseToReceive = TestData.failedDownloadResponse
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.download(episode: TestData.episode, session: mockNetworkSession) { continuation.resume(with: $0) }
            }
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

}

// MARK: - Combine Publisher Methods
extension EpisodesTests {

    @Test("Test combine create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenBatchInsertFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenFetchPodcastFails() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenFetchCreatedEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.errorToThrowForFetchObjects = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine create throws when fetch podcast returns nil",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenFetchPodcastReturnsNil() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Create should throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Incorrect error thrown")
            }
        }
    }

    @Test("Test combine create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        mockCoreData.errorToThrowForSaveAndRelateEpisodes = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {
        mockCoreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        mockCoreData.dataToReturnForFetchObjects = [EpisodeStorageObject(episode: TestData.episode,
                                                                         context: context)]
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.createPublisher([TestData.episode], forPodcast: TestData.podcast)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
        } catch {
            Issue.record("Create should not throw")
        }
    }

    @Test("Test combine delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteThrowsWhenDeleteEpisodesFails() async throws {
        mockCoreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.deletePublisher([TestData.episode])
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine delete throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteThrowsWhenFetchEpisodesFails() async throws {
        mockCoreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.deletePublisher([TestData.episode])
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.deletePublisher([TestData.episode])
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
        } catch {
            Issue.record("Delete should not throw")
        }
    }

    @Test("Test combine download throws when failing to fetch episode",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenFailingToFetchEpisode() async throws {
        mockCoreData.errorToThrowForFetchObject = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.downloadPublisher(episode: TestData.episode)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.downloadPublisher(episode: TestData.episode)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test combine cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineCleanupFilesCalledWhenDownloadEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockFileManager.errorToThrowForDownloadFile = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockHelpers.downloadPublisher(episode: TestData.episode)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch {
            #expect(mockFileManager.cleanupFilesCalled)
        }
    }

    @Test("Test combine download throws when downloading an episode fails network request",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadingAnEpisodeFailsNetworkRequest() async throws {
        mockNetworkSession.errorToThrow = URLError(.badServerResponse)
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.downloadPublisher(episode: TestData.episode, session: mockNetworkSession)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

    @Test("Test combine download throws when fetching episode fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenFetchingEpisodeFails() async throws {
        mockCoreData.dataToReturnForFetchObject = nil
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.downloadPublisher(episode: TestData.episode, session: mockNetworkSession)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as StorageError {
            switch error {
            case .objectNotFound:
                break
            default:
                Issue.record("Download should throw StorageError.objectNotFound")
            }
        }
    }

    @Test("Test combine download succeeds when nothing throws",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadSucceedsWhenNothingThrows() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.dataToReceive = TestData.validDownloadData
        mockNetworkSession.responseToReceive = TestData.successfulDownloadResponse
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.downloadPublisher(episode: TestData.episode, session: mockNetworkSession)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
        } catch  {
            Issue.record("Download should not throw")
        }
    }

    @Test("Test combine download fails when network response is failure",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenNetworkResponseIsFailure() async throws {
        mockCoreData.dataToReturnForFetchObject = EpisodeStorageObject(episode: TestData.episode, context: context)
        mockNetworkSession.responseToReceive = TestData.failedDownloadResponse
        do {
            try await withCheckedThrowingContinuation { continuation in
                subjectUsingMockNetworkSession.downloadPublisher(episode: TestData.episode, session: mockNetworkSession)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { value in
                        continuation.resume(returning: value)
                    })
                    .store(in: &cancellables)
            }
            Issue.record("Download should not throw")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }

}

extension EpisodesTests {
    struct TestData {
        // MARK: - Shared Data
        static let podcast: Podcast = Podcast.init(id: 1,
                                                   title: "",
                                                   image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
                                                   podcastDescription: "",
                                                   episodes: [episode]
        )

        static let episode: Episode = Episode(id: 1,
                                              title: "",
                                              audioLengthSEC: .zero,
                                              explicitContent: false,
                                              guid: "",
                                              datePublished: nil,
                                              episodeNumber: 1,
                                              enclosedURL: URL(string: "https://download.samplelib.com/mp3/sample-3s.mp3")!,
                                              season: 1,
                                              image: URL(string: "https://picsum.photos/seed/picsum/200/300")!
        )

        // MARK: - Download Data
        static let successfulDownloadResponse = HTTPURLResponse(
            url: URL(string: "https://download.samplelib.com/mp3/sample-3s.mp3")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let failedDownloadResponse = HTTPURLResponse(
            url: URL(string: "https://download.samplelib.com/mp3/sample-3s.mp3")!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        static let invalidDownloadData: Data? = nil
        static let validDownloadData: Data = {
            var randomBytes = [UInt8](repeating: 0, count: 10)
            let _ = randomBytes.withUnsafeMutableBytes {
                SecRandomCopyBytes(kSecRandomDefault, 10, $0.baseAddress!)
            }
            return Data(randomBytes)
        }()

        // MARK: - Errors
        enum Error: LocalizedError {
            case generic

            var localizedDescription: String {
                switch self {
                case .generic:
                    return "An error occurred."
                }
            }
        }
    }
}
