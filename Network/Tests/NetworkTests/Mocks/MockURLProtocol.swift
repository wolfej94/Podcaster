//
//  MockURLProtocol.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {

    nonisolated(unsafe)static var error: Error?
    nonisolated(unsafe)static var response: URLResponse?
    nonisolated(unsafe) static var data: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = Self.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
