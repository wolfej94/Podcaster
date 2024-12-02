//
//  NetworkURLSession.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation

/// Internal protocol to wrap URL Session
public protocol NetworkURLSession {

    /// Convenience method to create a data task using a URLRequest, creates a URLSessionDataTask internally.
    ///
    /// - Parameter request: The URLRequest for which to load data.
    /// - Parameter completionHandler: Completion handler that deals with any data, response or errors
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask

    /// Convenience method to load data using a URLRequest, creates and resumes a URLSessionDataTask internally.
    ///
    /// - Parameter request: The URLRequest for which to load data.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    func data(for request: URLRequest,
                     delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)

    /// Returns a publisher that wraps a URL session data task for a given URL request.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter request: The URL request for which to create a data task.
    /// - Returns: A publisher that wraps a data task for the URL request.
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkURLSession { }
