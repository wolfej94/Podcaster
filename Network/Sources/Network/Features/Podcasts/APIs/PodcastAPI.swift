//
//  PodcastAPI.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

import Foundation

enum PodcastAPI: API {

    case popular(page: Int, apiKey: String)
    case search(query: String, page: Int, apiKey: String)
    case recommended(basedOn: Podcast, page: Int, apiKey: String)

    private var url: URL {
        return switch self {
        case .popular(let page, _):
            Configuration.baseURL
                .appending(path: "best_podcasts")
                .appending(queryItems: [
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "sort", value: "listen_score"),
                    URLQueryItem(name: "safe_mode", value: "0")
                ])
        case .search(let query, let page, _):
            Configuration.baseURL
                .appending(path: "search")
                .appending(queryItems: [
                    URLQueryItem(name: "q", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
                    URLQueryItem(name: "safe_mode", value: "0"),
                    URLQueryItem(name: "page", value: String(page)),
                ])
        case .recommended(let basedOn, let page, _):
            Configuration.baseURL
                .appending(path: "podcasts/\(basedOn.id)/recommendations")
                .appending(queryItems: [
                    URLQueryItem(name: "safe_mode", value: "0"),
                    URLQueryItem(name: "page", value: String(page)),
                ])
        }
    }

    private var method: String {
        return switch self {
        case .popular, .search, .recommended: "GET"
        }
    }

    private var apiKey: String {
        switch self {
        case .popular(_, let apiKey), .search(_, _, let apiKey), .recommended(_, _, let apiKey):
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
