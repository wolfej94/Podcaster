//
//  HomeViewModel.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI
import Storage
import Repository

enum HomeViewAction {
    typealias Handler = (Self) -> Void
    case selected(podcast: PodcastViewModel)
}

@Observable final class HomeViewModel: ViewModel {

    private let podcastCommandFactory: PodcastCommandFactory
    private let actionHandler: HomeViewAction.Handler
    let tabItem: Label = Label("home", systemImage: "house")
    var podcasts = [PodcastViewModel]()

    init(podcastCommandFactory: PodcastCommandFactory = DefaultPodcastCommandFactory(),
         actionHandler: @escaping HomeViewAction.Handler) {
        self.podcastCommandFactory = podcastCommandFactory
        self.actionHandler = actionHandler
    }

    @MainActor
    func refreshPodcasts(ignoreCache: Bool) async {
        do {
            await setState(to: .loading)
            podcasts = try await podcastCommandFactory
                .refreshPodcastsCommand(ignoreCache: ignoreCache)
                .execute()
            await setState(to: .loaded)
        } catch {
            await setState(to: .error(message: "Could not update podcasts"))
            guard ignoreCache == true else { return }
            await refreshPodcasts(ignoreCache: false)
        }
    }

    func didTap(podcast: PodcastViewModel) {
        actionHandler(.selected(podcast: podcast))
    }

}
