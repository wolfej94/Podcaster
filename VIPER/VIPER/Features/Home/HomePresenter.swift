//
//  HomePresenter.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//


import Foundation
import Storage

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectPodcast(_ podcast: PodcastViewModel)
    func refreshPodcasts(ignoreCache: Bool)
}

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?

    private var podcasts: [PodcastViewModel] = []

    func viewDidLoad() {
        refreshPodcasts(ignoreCache: true)
    }

    func didSelectPodcast(_ podcast: PodcastViewModel) {
        router?.navigateToPodcastDetails(podcast)
    }

    func refreshPodcasts(ignoreCache: Bool) {
        view?.showLoading()
        interactor?.fetchPodcasts(ignoreCache: ignoreCache) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let podcasts):
                self?.view?.showPodcasts(podcasts)
            case .failure:
                self?.view?.showError("Could not update podcasts")
                self?.refreshPodcasts(ignoreCache: false)
                self?.refreshPodcasts(ignoreCache: false)
            }
        }
    }
}
