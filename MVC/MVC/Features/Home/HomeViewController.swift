//
//  HomeViewController.swift
//  MVC
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit
import Storage
import Repository

final class HomeViewController: UIViewController {

    private var podcasts: [PodcastViewModel] = []
    private let networkService = Repository(apiKey: Configuration.apiKey,
                                            secret: Configuration.apiSecret,
                                            userAgent: Configuration.bundleId)
    @IBOutlet private weak var popularShowsCollectionView: UICollectionView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!

    init() {
        super.init(nibName: "HomeView", bundle: .main)
        self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        refreshPodcasts(ignoreCache: true)
    }

    func showPodcasts(_ podcasts: [PodcastViewModel]) {
        self.podcasts = podcasts
            .sorted(by: { $0.id < $1.id })
        popularShowsCollectionView.reloadData()
    }

    func showLoading() {
        loadingView.startAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.contentView.alpha = 0
        }
    }

    func hideLoading() {
        loadingView.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.contentView.alpha = 1
        }
    }

    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }

    func didSelectPodcast(_ podcast: PodcastViewModel) {
        // TODO: - Navigation
        print("Navigating to \(podcast.title ?? "unnamed podcast")")
    }

    func refreshPodcasts(ignoreCache: Bool) {
        showLoading()
        networkService.popular(ignoreCache: ignoreCache) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let podcasts):
                    self?.podcasts = podcasts
                    self?.hideLoading()
                    self?.popularShowsCollectionView.reloadData()
                case .failure:
                    self?.showError("Could not update podcasts")
                    guard ignoreCache == true else { return }
                    self?.refreshPodcasts(ignoreCache: false)
                }
            }
        }
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    private func setupCollectionViews() {
        popularShowsCollectionView.dataSource = self
        popularShowsCollectionView.delegate = self
        let view = UINib(nibName: PodcastCollectionViewCell.reuseIdentifier,
                         bundle: .main)
        popularShowsCollectionView.register(view, forCellWithReuseIdentifier: PodcastCollectionViewCell.reuseIdentifier)
    }

    private func podcast(forIndex index: Int) -> PodcastViewModel? {
        guard podcasts.indices.contains(index) else { return nil }
        return podcasts[index]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let podcast = podcast(forIndex: indexPath.item) else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        (cell as? PodcastCollectionViewCell)?.updateContents(with: podcast)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let podcast = podcast(forIndex: indexPath.item) else { return }
        didSelectPodcast(podcast)
    }

}
