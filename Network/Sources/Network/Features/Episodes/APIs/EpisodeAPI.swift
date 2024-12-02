//
//  EpisodeAPI.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//


import Foundation

enum EpisodeAPI: API {

    case episodes(podcast: Podcast, apiKey: String)

    private var url: URL {
        return switch self {
        case .episodes(let podcast, _):
            Configuration.baseURL
                .appending(path: "podcasts/\(podcast.id)")
        }
    }

    private var method: String {
        return switch self {
        case .episodes: "GET"
        }
    }

    private var apiKey: String {
        switch self {
        case .episodes(_, let apiKey):
            return apiKey
        }
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(apiKey, forHTTPHeaderField: "X-ListenAPI-Key")
        return request
    }

}
