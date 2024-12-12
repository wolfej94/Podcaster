//
//  API.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation
import CryptoKit

internal protocol API {
    var request: URLRequest { get }
    var userAgent: String { get }
    var secret: String { get }
    var apiKey: String { get }
}

internal extension API {
    func generateHeaders() -> [String: String] {
        let unixTime = String(Int(Date().timeIntervalSince1970))
        let dataToHash = apiKey + secret + unixTime
        let hash = Insecure.SHA1.hash(data: Data(dataToHash.utf8))
        let authorization = hash.map { String(format: "%02x", $0) }.joined()

        return [
            "User-Agent": userAgent,
            "X-Auth-Key": apiKey,
            "X-Auth-Date": unixTime,
            "Authorization": authorization
        ]
    }
}
