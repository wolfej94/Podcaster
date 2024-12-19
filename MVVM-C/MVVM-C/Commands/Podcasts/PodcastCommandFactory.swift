//
//  PodcastCommandFactory.swift
//  MVVM-C
//
//  Created by James Wolfe on 19/12/2024.
//

import Repository

protocol PodcastCommandFactory {
    func refreshPodcastsCommand(ignoreCache: Bool) -> RefreshPodcastsCommand
}

final class DefaultPodcastCommandFactory: PodcastCommandFactory {

    private let networkService: Repository

    init(networkService: Repository = Repository(apiKey: Configuration.apiKey,
                                                 secret: Configuration.apiSecret,
                                                 userAgent: Configuration.bundleId)) {
        self.networkService = networkService
    }

    func refreshPodcastsCommand(ignoreCache: Bool) -> RefreshPodcastsCommand {
        RefreshPodcastsCommand(ignoreCache: ignoreCache, networkService: networkService)
    }
}
