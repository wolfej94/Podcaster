//
//  MockNetworkURLSession.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Network
import Combine
import Foundation
import Storage

final class MockNetworkURLSession: NetworkURLSession, @unchecked Sendable {

    var dataToReceive: Data? {
        set {
            MockURLProtocol.data = newValue
        } get {
            MockURLProtocol.data
        }
    }

    var responseToReceive: URLResponse? {
        set {
            MockURLProtocol.response = newValue
        } get {
            MockURLProtocol.response
        }
    }

    var errorToThrow: Error? {
        set {
            MockURLProtocol.error = newValue
        } get {
            MockURLProtocol.error
        }
    }

    init() {
        responseToReceive = nil
        dataToReceive = nil
        errorToThrow = nil
    }

    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        session.dataTask(with: request, completionHandler: completionHandler)
    }

    func data(for request: URLRequest,
              delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        try await session.data(for: request, delegate: delegate)
    }


    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }

}
