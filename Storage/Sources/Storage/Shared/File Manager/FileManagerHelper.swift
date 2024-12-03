//
//  StorageHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Foundation
import Combine

typealias FileManagerHelper = SynchronousFileManagerHelper & AsyncFileManagerHelper & ClosureFileManagerHelper & CombineFileManagerHelper
internal struct DefaultFileManagerHelper: SynchronousFileManagerHelper {

    func cleanUpFiles(for episode: Episode) throws {
        let urls = [episode.audio, episode.image, episode.thumbnail]
        for url in urls {
            guard let url = url else { continue }
            let fileURL = URL.applicationSupportDirectory.appending(path: url.path(percentEncoded: false))
            try FileManager.default.removeItem(at: fileURL)
        }
    }

}

// MARK: - Async/Await Methods
extension DefaultFileManagerHelper: AsyncFileManagerHelper {

    func downloadFile(at networkURL: URL?, session: NetworkURLSession) async throws -> URL {
        guard let networkURL = networkURL else { throw StorageError.missingURL }
        let request = URLRequest(url: networkURL)
        let (data, response) = try await session.data(for: request, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let fileURL = URL.applicationSupportDirectory.appending(path: networkURL.path(percentEncoded: false))
        let directoryURL = fileURL.deletingLastPathComponent()

        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        if !FileManager.default.createFile(atPath: fileURL.path(), contents: data) {
            throw StorageError.downloadFailed
        }
        return fileURL
    }

}

// MARK: - Closure Methods
extension DefaultFileManagerHelper: ClosureFileManagerHelper {

    func downloadFile(at networkURL: URL?, session: NetworkURLSession, completionHandler: @escaping @Sendable (Result<URL, Error>) -> Void) {
        guard let networkURL = networkURL else {
            completionHandler(.failure(StorageError.missingURL))
            return
        }

        let request = URLRequest(url: networkURL)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completionHandler(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let fileURL = URL.applicationSupportDirectory.appending(path: networkURL.path(percentEncoded: false))
                let directoryURL = fileURL.deletingLastPathComponent()

                if !FileManager.default.fileExists(atPath: directoryURL.path) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                if !FileManager.default.createFile(atPath: fileURL.path(), contents: data) {
                    throw StorageError.downloadFailed
                }
                completionHandler(.success(fileURL))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }

}

// MARK: - Combine Publisher Methods
extension DefaultFileManagerHelper: CombineFileManagerHelper {

    func downloadFilePublisher(at networkURL: URL?, session: NetworkURLSession) -> AnyPublisher<URL, Error> {
        guard let networkURL = networkURL else {
            return Fail(error: StorageError.missingURL).eraseToAnyPublisher()
        }

        let request = URLRequest(url: networkURL)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> URL in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                let fileURL = URL.applicationSupportDirectory.appending(path: networkURL.path(percentEncoded: false))
                let directoryURL = fileURL.deletingLastPathComponent()

                if !FileManager.default.fileExists(atPath: directoryURL.path) {
                    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                }
                if !FileManager.default.createFile(atPath: fileURL.path(), contents: data) {
                    throw StorageError.downloadFailed
                }
                return fileURL
            }
            .eraseToAnyPublisher()
    }

}
