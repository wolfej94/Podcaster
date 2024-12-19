//
//  HomeView.swift
//  VIPER
//
//  Created by James Wolfe on 18/12/2024.
//

import UIKit
import Storage

protocol HomeViewProtocol: UIViewController {
    func showPodcasts(_ podcasts: [PodcastViewModel])
    func showLoading()
    func hideLoading()
    func showError(_ error: String)
}

final class HomeView: UIViewController, HomeViewProtocol {

    var presenter: HomePresenterProtocol?
    private var podcasts: [PodcastViewModel] = []
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
        presenter?.viewDidLoad()
        setupCollectionViews()
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

}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {

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
        presenter?.didSelectPodcast(podcast)
    }
}
