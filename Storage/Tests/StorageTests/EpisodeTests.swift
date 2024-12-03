import Testing
import Foundation
import Combine
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
    @Tag static var update: Tag
    @Tag static var delete: Tag
    @Tag static var download: Tag
}

@Suite("Episodes Storage Tests")
final class EpisodesTests {

    let mockNetworkSession: MockNetworkURLSession
    let fileManager: DefaultFileManagerHelper
    let mockFileManager: MockFileManagerHelper
    let mockCoreData: MockCoreDataHelper
    let subjectUsingMockHelpers: StorageService
    let subjectUsingMockNetworkSession: StorageService

    init() {
        self.mockFileManager = MockFileManagerHelper()
        self.mockCoreData = MockCoreDataHelper()
        self.subjectUsingMockHelpers = DefaultStorageService(fileManager: mockFileManager,
                                                             coreData: mockCoreData)

        self.mockNetworkSession = MockNetworkURLSession()
        self.fileManager = DefaultFileManagerHelper()
        self.subjectUsingMockNetworkSession = DefaultStorageService(fileManager: fileManager,
                                                                    coreData: mockCoreData)
    }

}

// MARK: - Synchronous Methods
extension EpisodesTests {
    @Test("Test error throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.sync, Tag.EpisodeTestTag.read)
    )
    func errorThrowsWhenFetchEpisodesFails() throws {

    }

    @Test("Test data returned when fetch episodes succeeds",
          .tags(Tag.EpisodeTestTag.sync, Tag.EpisodeTestTag.read)
    )
    func dataReturnedThrowWhenFetchEpisodesSucceeds() throws {

    }
}

// MARK: - Async/Await Methods
extension EpisodesTests {

    @Test("Test async create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test async create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test async create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test async create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test async create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.create)
    )
    func asyncCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test async update throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.update)
    )
    func asyncUpdateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test async update throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.update)
    )
    func asyncUpdateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test async update throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.update)
    )
    func asyncUpdateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test async update throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.update)
    )
    func asyncUpdateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test async update does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.update)
    )
    func asyncUpdateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test async delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteThrowsWhenDeleteEpisodesFails() async throws {

    }

    @Test("Test async delete throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteThrowsWhenFetchEpisodesFails() async throws {

    }

    @Test("Test async delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.delete)
    )
    func asyncDeleteDoesNotThrowWhenDeleteSucceeds() async throws {

    }

    @Test("Test async download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {

    }

    @Test("Test async cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncCleanupFilesCalledWhenDownloadEpisodeFails() async throws {

    }

    @Test("Test async download throws when downloading an episode and download audio fails network request",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadingAnEpisodeAndDownloadAudioFailsNetworkRequest() async throws {

    }

    @Test("Test async download throws when download image fails network request",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadingAnEpisodeAndDownloaImageFailsNetworkRequest() async throws {

    }

    @Test("Test async download throws when download thumbnail fails network request",
          .tags(Tag.EpisodeTestTag.async, Tag.EpisodeTestTag.download)
    )
    func asyncDownloadThrowsWhenDownloadingAnEpisodeAndDownloadThumbnailFailsNetworkRequest() async throws {

    }

}

// MARK: - Closure Methods
extension EpisodesTests {

    @Test("Test closure create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test closure create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test closure create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test closure create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test closure create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.create)
    )
    func closureCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test closure update throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.update)
    )
    func closureUpdateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test closure update throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.update)
    )
    func closureUpdateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test closure update throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.update)
    )
    func closureUpdateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test closure update throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.update)
    )
    func closureUpdateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test closure update does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.update)
    )
    func closureUpdateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test closure delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteThrowsWhenDeleteEpisodesFails() async throws {

    }

    @Test("Test closure delete throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteThrowsWhenFetchEpisodesFails() async throws {

    }

    @Test("Test closure delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.delete)
    )
    func closureDeleteDoesNotThrowWhenDeleteSucceeds() async throws {

    }

    @Test("Test closure download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {

    }

    @Test("Test closure cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureCleanupFilesCalledWhenDownloadEpisodeFails() async throws {

    }

    @Test("Test closure download throws when downloading an episode and download audio fails network request",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadingAnEpisodeAndDownloadAudioFailsNetworkRequest() async throws {

    }

    @Test("Test closure download throws when download image fails network request",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadingAnEpisodeAndDownloaImageFailsNetworkRequest() async throws {

    }

    @Test("Test closure download throws when download thumbnail fails network request",
          .tags(Tag.EpisodeTestTag.closure, Tag.EpisodeTestTag.download)
    )
    func closureDownloadThrowsWhenDownloadingAnEpisodeAndDownloadThumbnailFailsNetworkRequest() async throws {

    }

}

// MARK: - Combine Publisher Methods
extension EpisodesTests {

    @Test("Test combine create throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test combine create throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test combine create throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test combine create throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test combine create does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.create)
    )
    func combineCreateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test combine update throws when batch insert fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.update)
    )
    func combineUpdateThrowsWhenBatchInsertFails() async throws {

    }

    @Test("Test combine update throws when fetch podcast fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.update)
    )
    func combineUpdateThrowsWhenFetchPodcastFails() async throws {

    }

    @Test("Test combine update throws when fetch created episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.update)
    )
    func combineUpdateThrowsWhenFetchPodcastIDFails() async throws {

    }

    @Test("Test combine update throws when save and relate episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.update)
    )
    func combineUpdateThrowsWhenSaveAndRelateEpisodesFails() async throws {

    }

    @Test("Test combine update does not throw when create episodes succeeds",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.update)
    )
    func combineUpdateDoesNotThrowWhenCreateEpisodesSucceeds() async throws {

    }

    @Test("Test combine delete throws when delete episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteThrowsWhenDeleteEpisodesFails() async throws {

    }

    @Test("Test combine delete throws when fetch episodes fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteThrowsWhenFetchEpisodesFails() async throws {

    }

    @Test("Test combine delete does not throw when delete episodes succeeds",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.delete)
    )
    func combineDeleteDoesNotThrowWhenDeleteSucceeds() async throws {

    }

    @Test("Test combine download throws when failing to store in file manager",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadEpisodeFailsToStoreInFileManager() async throws {

    }

    @Test("Test combine cleanup files called when download episode fails",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineCleanupFilesCalledWhenDownloadEpisodeFails() async throws {

    }

    @Test("Test combine download throws when downloading an episode and download audio fails network request",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadingAnEpisodeAndDownloadAudioFailsNetworkRequest() async throws {

    }

    @Test("Test combine download throws when download image fails network request",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadingAnEpisodeAndDownloaImageFailsNetworkRequest() async throws {

    }

    @Test("Test combine download throws when download thumbnail fails network request",
          .tags(Tag.EpisodeTestTag.combine, Tag.EpisodeTestTag.download)
    )
    func combineDownloadThrowsWhenDownloadingAnEpisodeAndDownloadThumbnailFailsNetworkRequest() async throws {

    }

}

extension EpisodesTests {

    // MARK: - Shared Data
    static let podcast: Podcast = Podcast(
        id: "",
        email: "",
        image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
        title: "",
        country: "",
        website: nil,
        language: "",
        genres: [],
        publisher: "",
        thumbnail: URL(string: "https://picsum.photos/seed/picsum/50/50")!,
        summary: "",
        listenScore: .zero,
        totalEpisodes: .zero,
        explicitContent: false,
        latestEpisodeID: "",
        latestPubDateMS: nil,
        earliestPubDateMS: nil,
        updateFrequencyHours: .zero,
        listenScoreGlobalRank: ""
    )
    static let episode: Episode = Episode(
        id: "",
        audio: URL(string: "https://example.com")!,
        image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
        title: "",
        thumbnail: URL(string: "https://picsum.photos/seed/picsum/50/50")!,
        summary: "",
        pubDateMS: nil,
        audioLengthSEC: .zero,
        explicitContent: false
    )

    // MARK: - Download Data
    static let successfulDownloadResponse = HTTPURLResponse(
        url: URL(string: "https://example.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )
    static let failedDownloadResponse = HTTPURLResponse(
        url: URL(string: "https://example.com")!,
        statusCode: 403,
        httpVersion: nil,
        headerFields: nil
    )
    static let invalidDownloadData: Data? = nil
    static let validDownloadData = Data()

    // MARK: - Errors
    enum Error: LocalizedError {
        case generic
    }
}
