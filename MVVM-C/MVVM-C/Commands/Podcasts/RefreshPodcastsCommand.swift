//
//  RefreshPodcastsCommand.swift
//  MVVM-C
//
//  Created by James Wolfe on 19/12/2024.
//

import Repository
import Storage

struct RefreshPodcastsCommand: AsyncCommand {

    private let ignoreCache: Bool
    private let networkService: Repository

    init(ignoreCache: Bool, networkService: Repository) {
        self.ignoreCache = ignoreCache
        self.networkService = networkService
    }

    func execute() async throws -> [PodcastViewModel] {
        try await networkService.popular(ignoreCache: ignoreCache)
    }

}
