//
//  FutureResultWrapper.swift
//  Repository
//
//  Created by James Wolfe on 11/12/2024.
//

import Combine

class FutureResultWrapper<Output, Failure: Error>: @unchecked Sendable {
    typealias Promise = (Result<Output, Failure>) -> Void

    let completionResult: Promise

    /// Creates a publisher that invokes a promise closure when the publisher emits an element.
    ///
    /// - Parameter attemptToFulfill: A ``Future/Promise`` that the publisher invokes when the publisher emits an element or terminates with an error.
    init(_ attemptToFulfill: @escaping Promise) {
        self.completionResult = attemptToFulfill
    }
}
