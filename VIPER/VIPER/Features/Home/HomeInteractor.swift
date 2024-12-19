//
//  HomeInteractor.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import Foundation
import Storage
import Repository

protocol HomeInteractorProtocol: AnyObject {
    func fetchPodcasts(ignoreCache: Bool, completion: @escaping (Result<[PodcastViewModel], Error>) -> Void)
}

final class HomeInteractor: HomeInteractorProtocol {
    
    var presenter: HomePresenterProtocol?
    private let networkService = Repository(apiKey: Configuration.apiKey,
                                            secret: Configuration.apiSecret,
                                            userAgent: Configuration.bundleId)

    func fetchPodcasts(ignoreCache: Bool, completion: @escaping (Result<[PodcastViewModel], any Error>) -> Void) {
        networkService.popular(ignoreCache: ignoreCache) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
