//
//  PodcastTests.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Testing
import Foundation
import Combine
import CoreData
@testable import Storage

extension Tag {
    enum PodcastTestTag {}
}

extension Tag.PodcastTestTag {
    @Tag static var sync: Tag
    @Tag static var async: Tag
    @Tag static var combine: Tag
    @Tag static var closure: Tag
    @Tag static var create: Tag
    @Tag static var read: Tag
    @Tag static var update: Tag
    @Tag static var delete: Tag
}

@Suite("Podcasts Storage Tests")
final class PodcastTests {

    let coreData: MockCoreDataHelper
    let subject: DefaultStorageService
    let context: NSManagedObjectContext
    var cancellables = Set<AnyCancellable>()

    init() {
        let fileManager = MockFileManagerHelper()
        self.coreData = MockCoreDataHelper()
        self.subject = DefaultStorageService(fileManager: fileManager,
                                                             coreData: coreData)
        self.context = subject.container.viewContext
    }

}

// MARK: - Synchronous Methods
extension PodcastTests {
    @Test("Test error throws when fetch podcasts fails",
          .tags(Tag.PodcastTestTag.sync, Tag.PodcastTestTag.read)
    )
    func errorThrowsWhenFetchPodcastsFails() throws {
        coreData.errorToThrowForFetchObjects = TestData.Error.generic
        do {
            _ = try subject.read()
            Issue.record("Fetch should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test data returned when fetch podcasts succeeds",
          .tags(Tag.PodcastTestTag.sync, Tag.PodcastTestTag.read)
    )
    func dataReturnedThrowWhenFetchPodcastsSucceeds() throws {
        coreData.dataToReturnForFetchObjects = [PodcastStorageObject(podcast: TestData.podcast, context: context)]
        let podcast = try subject.read().first
        #expect(podcast?.id == TestData.podcast.id)
    }
}

// MARK: - Async/Await Methods
extension PodcastTests {

    @Test("Test async create throws when batch insert fails",
          .tags(Tag.PodcastTestTag.async, Tag.PodcastTestTag.create)
    )
    func asyncCreateThrowsWhenBatchInsertFails() async throws {
        coreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                       context: context)
        coreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            _ = try await subject.create([TestData.podcast])
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async create does not throw when create podcasts succeeds",
          .tags(Tag.PodcastTestTag.async, Tag.PodcastTestTag.create)
    )
    func asyncCreateDoesNotThrowWhenCreatePodcastsSucceeds() async throws {
        coreData.dataToReturnForFetchObjects = [PodcastStorageObject(podcast: TestData.podcast,
                                                                         context: context)]
        do {
            _ = try await subject.create([TestData.podcast])
        } catch {
            Issue.record("Create should not throw")
        }
    }

    @Test("Test async delete throws when delete podcasts fails",
          .tags(Tag.PodcastTestTag.async, Tag.PodcastTestTag.delete)
    )
    func asyncDeleteThrowsWhenDeletePodcastsFails() async throws {
        coreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await subject.delete([TestData.podcast])
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async delete throws when fetch podcast IDs fails",
          .tags(Tag.PodcastTestTag.async, Tag.PodcastTestTag.delete)
    )
    func asyncDeleteThrowsWhenFetchPodcastIDssFails() async throws {
        coreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await subject.delete([TestData.podcast])
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test async delete does not throw when delete podcasts succeeds",
          .tags(Tag.PodcastTestTag.async, Tag.PodcastTestTag.delete)
    )
    func asyncDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await subject.delete([TestData.podcast])
        } catch {
            Issue.record("Delete should not throw")
        }
    }

}

// MARK: - Closure Methods
extension PodcastTests {

    @Test("Test closure create throws when batch insert fails",
          .tags(Tag.PodcastTestTag.closure, Tag.PodcastTestTag.create)
    )
    func closureCreateThrowsWhenBatchInsertFails() async throws {
        coreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                   context: context)
        coreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.create([TestData.podcast]) { continuation.resume(with: $0)}
            }
            Issue.record("Create should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure create does not throw when create podcasts succeeds",
          .tags(Tag.PodcastTestTag.closure, Tag.PodcastTestTag.create)
    )
    func closureCreateDoesNotThrowWhenCreatePodcastsSucceeds() async throws {
        coreData.dataToReturnForFetchObjects = [PodcastStorageObject(podcast: TestData.podcast,
                                                                     context: context)]
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.create([TestData.podcast]) { continuation.resume(with: $0)}
            }
        } catch {
            Issue.record("Create should not throw")
        }
    }

    @Test("Test closure delete throws when delete podcasts fails",
          .tags(Tag.PodcastTestTag.closure, Tag.PodcastTestTag.delete)
    )
    func closureDeleteThrowsWhenDeletePodcastsFails() async throws {
        coreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.delete([TestData.podcast]) { continuation.resume(with: $0)}
            }
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure delete throws when fetch podcast IDs fails",
          .tags(Tag.PodcastTestTag.closure, Tag.PodcastTestTag.delete)
    )
    func closureDeleteThrowsWhenFetchPodcastIDssFails() async throws {
        coreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.delete([TestData.podcast]) { continuation.resume(with: $0)}
            }
            Issue.record("Delete should throw")
        } catch let error as TestData.Error {
            #expect(error == .generic)
        }
    }

    @Test("Test closure delete does not throw when delete podcasts succeeds",
          .tags(Tag.PodcastTestTag.closure, Tag.PodcastTestTag.delete)
    )
    func closureDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.delete([TestData.podcast]) { continuation.resume(with: $0)}
            }
        } catch {
            Issue.record("Delete should not throw")
        }
    }

}

// MARK: - Combine Publisher Methods
extension PodcastTests {

    @Test("Test combine create throws when batch insert fails",
          .tags(Tag.PodcastTestTag.combine, Tag.PodcastTestTag.create)
    )
    func combineCreateThrowsWhenBatchInsertFails() async throws {
        coreData.dataToReturnForFetchObject = PodcastStorageObject(podcast: TestData.podcast,
                                                                   context: context)
        coreData.errorToThrowForBatchInsert = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.createPublisher([TestData.podcast])
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

    @Test("Test combine create does not throw when create podcasts succeeds",
          .tags(Tag.PodcastTestTag.combine, Tag.PodcastTestTag.create)
    )
    func combineCreateDoesNotThrowWhenCreatePodcastsSucceeds() async throws {
        coreData.dataToReturnForFetchObjects = [PodcastStorageObject(podcast: TestData.podcast,
                                                                     context: context)]
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.createPublisher([TestData.podcast])
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

    @Test("Test combine delete throws when delete podcasts fails",
          .tags(Tag.PodcastTestTag.combine, Tag.PodcastTestTag.delete)
    )
    func combineDeleteThrowsWhenDeletePodcastsFails() async throws {
        coreData.errorToThrowForBatchDelete = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.deletePublisher([TestData.podcast])
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

    @Test("Test combine delete throws when fetch podcast IDs fails",
          .tags(Tag.PodcastTestTag.combine, Tag.PodcastTestTag.delete)
    )
    func combineDeleteThrowsWhenFetchPodcastIDssFails() async throws {
        coreData.errorToThrowForFetchObjectIDs = TestData.Error.generic
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.deletePublisher([TestData.podcast])
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

    @Test("Test combine delete does not throw when delete podcasts succeeds",
          .tags(Tag.PodcastTestTag.combine, Tag.PodcastTestTag.delete)
    )
    func combineDeleteDoesNotThrowWhenDeleteSucceeds() async throws {
        do {
            try await withCheckedThrowingContinuation { continuation in
                subject.deletePublisher([TestData.podcast])
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

}

extension PodcastTests {
    struct TestData {
        // MARK: - Shared Data
        static let podcast = PodcastViewModel(id: 1,
                                              title: "Test",
                                              image: URL(string: "https://picsum.photos/seed/picsum/200/300")!,
                                              podcastDescription: "",
                                              episodes: []
        )

        // MARK: - Errors
        enum Error: LocalizedError {
            case generic
        }
    }
}
