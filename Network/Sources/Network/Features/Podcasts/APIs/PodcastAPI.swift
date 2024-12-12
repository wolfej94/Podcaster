//
//  PodcastAPI.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

import Foundation

internal enum PodcastAPI: API {

    case popular(page: Int, apiKey: String, secret: String, appName: String, appVersion: String)
    case search(query: String, page: Int, apiKey: String, secret: String, appName: String, appVersion: String)

    internal var apiKey: String {
        switch self {
        case .popular(_, let apiKey, _, _, _),
                .search(_, _, let apiKey, _, _, _):
            return apiKey
        }
    }

    internal var secret: String {
        switch self {
        case .popular(_, _, let secret, _, _),
                .search(_, _, _, let secret, _, _):
            return secret
        }
    }

    internal var userAgent: String {
        switch self {
        case .popular(_, _, _, let appName, let appVersion),
                .search(_, _, _, _, let appName, let appVersion):
            return [appName, appVersion].joined(separator: "/")
        }
    }

    private var url: URL {
        switch self {
        case .popular(let page, _, _, _, _):
            return Configuration.baseURL
                .appending(path: "podcasts/trending")
                .appending(queryItems: [
                    URLQueryItem(name: "max", value: "20"),
                    URLQueryItem(name: "page", value: String(page))
                ])
        case .search(let query, let page, _, _, _, _):
            return Configuration.baseURL
                .appending(path: "search/byterm")
                .appending(queryItems: [
                    URLQueryItem(name: "q", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
                    URLQueryItem(name: "max", value: "20"),
                    URLQueryItem(name: "page", value: String(page))
                ])
        }
    }

    private var method: String {
        return "GET"
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method

        let headers = generateHeaders()
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

