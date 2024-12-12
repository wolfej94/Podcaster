// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreData
import Combine

public final class DefaultStorageService: StorageService, @unchecked Sendable {

    internal let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    private let fileManager: FileManagerHelper
    private let coreData: CoreDataHelper
    private var cancellables = Set<AnyCancellable>()

    /// Internal initializer for use in testing only
    internal init(fileManager: FileManagerHelper, coreData: CoreDataHelper) {
        self.fileManager = fileManager
        self.coreData = coreData
        guard let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel.init(contentsOf: modelURL) else {
            fatalError("Model not found")
        }

        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        // Keep persistent storage in memory for test
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        container.loadPersistentStores { descriptions, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
    }

    public init() {
        fileManager = DefaultFileManagerHelper()
        coreData = DefaultCoreDataHelper()
        guard let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel.init(contentsOf: modelURL) else {
            fatalError("Model not found")
        }
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
    }

    public func read() throws -> [PodcastViewModel] {
        return try coreData.fetchManagedObjects(ofType: PodcastStorageObject.self, byIDs: nil, in: container.viewContext)
            .map { PodcastViewModel(from: $0) }
    }

}

// MARK: - Async Await Methods
public extension DefaultStorageService {
    func create(_ podcasts: [PodcastViewModel]) async throws {
        let podcastDictionaries = podcasts.map { $0.toDictionary() }
        try await coreData.batchInsert(entityName: "PodcastStorageObject", objects: podcastDictionaries, in: backgroundContext)
    }

    func create(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) async throws {
        guard let podcastStorageObject = try coreData.fetchManagedObject(
            ofType: PodcastStorageObject.self, byID: podcast.id, in: backgroundContext
        ) else {
            throw StorageError.objectNotFound("Podcast with ID \(podcast.id) not found.")
        }

        let episodeIDs = episodes.map { $0.id }
        let existingEpisodes = try coreData.fetchManagedObjects(
            ofType: EpisodeStorageObject.self, byIDs: episodeIDs, in: backgroundContext
        )

        let newEpisodes = episodes.filter { episode in
            existingEpisodes.first { $0.id == episode.id } == nil
        }

        let episodeDictionaries = newEpisodes.map { $0.toDictionary() }
        try await coreData.batchInsert(entityName: "EpisodeStorageObject", objects: episodeDictionaries, in: backgroundContext)

        let insertedEpisodes = try coreData.fetchManagedObjects(
            ofType: EpisodeStorageObject.self, byIDs: episodeIDs, in: backgroundContext
        )

        try await coreData.saveAndRelateEpisodes(insertedEpisodes, to: podcastStorageObject, in: backgroundContext)
    }

    func delete(_ podcasts: [PodcastViewModel]) async throws {
        let objectIDs = try coreData.fetchObjectIDs(ofType: PodcastStorageObject.self, for: podcasts.map { $0.id }, in: backgroundContext)
        try await coreData.batchDelete(objectIDs: objectIDs, in: backgroundContext)
    }

    func delete(_ episodes: [EpisodeViewModel]) async throws {
        let objectIDs = try coreData.fetchObjectIDs(ofType: EpisodeStorageObject.self, for: episodes.map { $0.id }, in: backgroundContext)
        try await coreData.batchDelete(objectIDs: objectIDs, in: backgroundContext)
    }

    func download(episode: EpisodeViewModel, session: NetworkURLSession = URLSession.shared) async throws {
        guard let episodeStorageObject = try coreData.fetchManagedObject(ofType: EpisodeStorageObject.self, byID: episode.id, in: backgroundContext) else {
            throw StorageError.objectNotFound("Podcast Episode with ID \(episode.id) not found.")
        }
        do {
            let audioFile = try await fileManager.downloadFile(at: episodeStorageObject.enclosedURL, session: session)
            let imageFile = try await fileManager.downloadFile(at: episodeStorageObject.image, session: session)

            try await withCheckedThrowingContinuation { continuation in
                backgroundContext.performAndWait { [weak self] in
                    do {
                        episodeStorageObject.enclosedURL = audioFile
                        episodeStorageObject.image = imageFile
                        episodeStorageObject.availableOffline = true
                        try self?.backgroundContext.save()
                        continuation.resume()
                    } catch {
                        try? self?.fileManager.cleanUpFiles(for: episode)
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            try? fileManager.cleanUpFiles(for: episode)
            throw error
        }
    }
}

// MARK: - Closure Methods
public extension DefaultStorageService {
    func create(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let podcastDictionaries = podcasts.map { $0.toDictionary() }
        coreData.batchInsert(entityName: "PodcastStorageObject", objects: podcastDictionaries, in: backgroundContext, completion: completion)
    }

    func create(_ episodes: [EpisodeViewModel], forPodcast podcast:PodcastViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let podcastStorageObject = try coreData.fetchManagedObject(
                ofType: PodcastStorageObject.self, byID: podcast.id, in: backgroundContext
            ) else {
                throw StorageError.objectNotFound("Podcast with ID \(podcast.id) not found.")
            }

            let episodeDictionaries = episodes.map { $0.toDictionary() }
            coreData.batchInsert(entityName: "EpisodeStorageObject", objects: episodeDictionaries, in: backgroundContext) { [weak self] result in
                guard let self else { return }
                do {
                    switch result {
                    case .success:
                        let episodeIDs = episodes.map { $0.id }
                        let insertedEpisodes = try self.coreData.fetchManagedObjects(
                            ofType: EpisodeStorageObject.self, byIDs: episodeIDs, in: backgroundContext
                        )

                        coreData.saveAndRelateEpisodes(insertedEpisodes, to: podcastStorageObject, in: backgroundContext, completion: completion)
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }

    func delete(_ podcasts: [PodcastViewModel], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let objectIDs = try coreData.fetchObjectIDs(ofType: PodcastStorageObject.self, for: podcasts.map { $0.id }, in: backgroundContext)
            coreData.batchDelete(objectIDs: objectIDs, in: backgroundContext, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func delete(_ episodes: [EpisodeViewModel], completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let objectIDs = try coreData.fetchObjectIDs(ofType: EpisodeStorageObject.self, for: episodes.map { $0.id }, in: backgroundContext)
            coreData.batchDelete(objectIDs: objectIDs, in: backgroundContext, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func download(episode: EpisodeViewModel, session: NetworkURLSession = URLSession.shared, completion: @escaping @Sendable (Result<Void, Error>) -> Void) {
        do {
            guard let episodeStorageObject = try coreData.fetchManagedObject(ofType: EpisodeStorageObject.self, byID: episode.id, in: backgroundContext) else {
                throw StorageError.objectNotFound("Podcast Episode with ID \(episode.id) not found.")
            }

            fileManager.downloadFile(at: episodeStorageObject.enclosedURL, session: session) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let audioFile):
                    self.fileManager.downloadFile(at: episodeStorageObject.image, session: session) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let imageFile):
                            self.backgroundContext.performAndWait { [weak self] in
                                do {
                                    episodeStorageObject.enclosedURL = audioFile
                                    episodeStorageObject.image = imageFile
                                    episodeStorageObject.availableOffline = true
                                    try self?.backgroundContext.save()
                                    completion(.success(()))
                                } catch {
                                    try? self?.fileManager.cleanUpFiles(for: episode)
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            try? self.fileManager.cleanUpFiles(for: episode)
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    try? self.fileManager.cleanUpFiles(for: episode)
                    completion(.failure(error))
                }
            }
        } catch {
            try? self.fileManager.cleanUpFiles(for: episode)
            completion(.failure(error))
        }
    }
}

// MARK: - Combine Publisher Methods
public extension DefaultStorageService {

    func createPublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            let podcastDictionaries = podcasts.map { $0.toDictionary() }
            self.coreData.batchInsert(entityName: "PodcastStorageObject", objects: podcastDictionaries, in: self.backgroundContext) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func createPublisher(_ episodes: [EpisodeViewModel], forPodcast podcast: PodcastViewModel) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            do {
                guard let podcastStorageObject = try self.coreData.fetchManagedObject(
                    ofType: PodcastStorageObject.self, byID: podcast.id, in: self.backgroundContext
                ) else {
                    throw StorageError.objectNotFound("Podcast with ID \(podcast.id) not found.")
                }

                let episodeDictionaries = episodes.map { $0.toDictionary() }
                self.coreData.batchInsert(entityName: "EpisodeStorageObject", objects: episodeDictionaries, in: self.backgroundContext) { result in
                    switch result {
                    case .success:
                        do {
                            let episodeIDs = episodes.map { $0.id }
                            let insertedEpisodes = try self.coreData.fetchManagedObjects(
                                ofType: EpisodeStorageObject.self, byIDs: episodeIDs, in: self.backgroundContext
                            )

                            self.coreData.saveAndRelateEpisodes(insertedEpisodes, to: podcastStorageObject, in: self.backgroundContext) { result in
                                switch result {
                                case .success:
                                    promise(.success(()))
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func deletePublisher(_ podcasts: [PodcastViewModel]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            do {
                let objectIDs = try self.coreData.fetchObjectIDs(ofType: PodcastStorageObject.self, for: podcasts.map { $0.id }, in: self.backgroundContext)
                self.coreData.batchDelete(objectIDs: objectIDs, in: self.backgroundContext) { result in
                    switch result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func deletePublisher(_ episodes: [EpisodeViewModel]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            do {
                let objectIDs = try self.coreData.fetchObjectIDs(ofType: EpisodeStorageObject.self, for: episodes.map { $0.id }, in: self.backgroundContext)
                self.coreData.batchDelete(objectIDs: objectIDs, in: self.backgroundContext) { result in
                    switch result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func downloadPublisher(episode: EpisodeViewModel, session: NetworkURLSession = URLSession.shared) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            do {
                guard let episodeStorageObject = try self.coreData.fetchManagedObject(ofType: EpisodeStorageObject.self, byID: episode.id, in: self.backgroundContext) else {
                    throw StorageError.objectNotFound("Podcast Episode with ID \(episode.id) not found.")
                }

                self.fileManager.downloadFilePublisher(at: episodeStorageObject.enclosedURL, session: session)
                    .flatMap { audioFile in
                        self.fileManager.downloadFilePublisher(at: episodeStorageObject.image, session: session)
                            .map { imageFile in (audioFile, imageFile) }
                    }
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                try? self.fileManager.cleanUpFiles(for: episode)
                                promise(.failure(error))
                            }
                        },
                        receiveValue: { audioFile, imageFile in
                            self.backgroundContext.performAndWait { [weak self] in
                                do {
                                    episodeStorageObject.enclosedURL = audioFile
                                    episodeStorageObject.image = imageFile
                                    episodeStorageObject.availableOffline = true
                                    try self?.backgroundContext.save()
                                    promise(.success(()))
                                } catch {
                                    try? self?.fileManager.cleanUpFiles(for: episode)
                                    promise(.failure(error))
                                }
                            }
                        }
                    )
                    .store(in: &cancellables)
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

}
