//
//  PodcastRecommendationsResponse.swift
//  Network
//
//  Created by James Wolfe on 01/12/2024.
//

struct PodcastRecommendationsResponse: Decodable {
    let recommendations: [Podcast]
}
