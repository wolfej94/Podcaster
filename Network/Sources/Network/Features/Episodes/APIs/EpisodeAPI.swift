//
//  EpisodeAPI.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation
import CryptoKit

internal enum EpisodeAPI: API {

    case episodes(podcast: Podcast, apiKey: String, secret: String, appName: String, appVersion: String)

    internal var apiKey: String {
        switch self {
        case .episodes(_, let apiKey, _, _, _):
            return apiKey
        }
    }

    internal var secret: String {
        switch self {
        case .episodes(_, _, let secret, _, _):
            return secret
        }
    }

    internal var userAgent: String {
        switch self {
        case .episodes(_, _, _, let appName, let appVersion):
            return "\(appName)/\(appVersion)"
        }
    }

    private var url: URL {
        switch self {
        case .episodes(let podcast, _, _, _, _):
            return Configuration.baseURL
                .appending(path: "/episodes/bypodcastguid")
                .appending(queryItems: [
                    URLQueryItem(name: "id", value: podcast.feedID) // Assuming `Podcast.feedID` is the podcast GUID
                ])
        }
    }

    private var method: String {
        switch self {
        case .episodes: "GET"
        }
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method

        // Add headers
        let headers = generateHeaders()
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
