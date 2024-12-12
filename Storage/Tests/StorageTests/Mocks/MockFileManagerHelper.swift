//
//  MockFileManagerHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

@testable import Storage
import Foundation
import Combine

final class MockFileManagerHelper: FileManagerHelper {

    var errorToThrowForDownloadFile: Error?
    var cleanupFilesCalled = false

    var urlToReturnFromDownloadFile: URL!

    func downloadFile(at networkURL: URL?, session: any Storage.NetworkURLSession) async throws -> URL {
        if let errorToThrowForDownloadFile {
            throw errorToThrowForDownloadFile
        }
        return urlToReturnFromDownloadFile
    }
    
    func downloadFile(at networkURL: URL?, session: any Storage.NetworkURLSession, completionHandler: @escaping @Sendable (Result<URL, any Error>) -> Void) {
        if let errorToThrowForDownloadFile {
            completionHandler(.failure(errorToThrowForDownloadFile))
            return
        }
        completionHandler(.success(urlToReturnFromDownloadFile))
    }
    
    func downloadFilePublisher(at networkURL: URL?, session: any Storage.NetworkURLSession) -> AnyPublisher<URL, any Error> {
        if let errorToThrowForDownloadFile {
            return Fail(error: errorToThrowForDownloadFile).eraseToAnyPublisher()
        }
        return Just(urlToReturnFromDownloadFile)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func cleanUpFiles(for episode: Storage.EpisodeViewModel) throws {
        cleanupFilesCalled = true
    }

}
