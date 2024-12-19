//
//  HomeViewModel.swift
//  MVVM
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI
import Storage
import Repository
import Combine

@Observable final class HomeViewModel: ViewModel {

    private let networkService = Repository(apiKey: Configuration.apiKey,
                                            secret: Configuration.apiSecret,
                                            userAgent: Configuration.bundleId)
    private var cancellables = Set<AnyCancellable>()
    let tabItem: Label = Label("home", systemImage: "house")
    var podcasts = [PodcastViewModel]()

    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }

    func refreshPodcasts(ignoreCache: Bool) {
        setState(to: .loading)
        networkService.popularPublisher(ignoreCache: ignoreCache)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.setState(to: .error(message: "Could not update podcasts"))
                    guard ignoreCache == true else { return }
                    self?.refreshPodcasts(ignoreCache: false)
                }
            }, receiveValue: { value in
                DispatchQueue.main.async { [weak self] in
                    self?.podcasts = value
                    self?.setState(to: .loaded)
                }
            })
            .store(in: &cancellables)
    }

    func didTap(podcast: PodcastViewModel) {
        // TODO: - Navigation
        print("Navigating to \(podcast.title ?? "unnamed podcast")")
    }

}
