//
//  PodcastCollectionViewCell.swift
//  VIPER
//
//  Created by James Wolfe on 19/12/2024.
//

import UIKit
import Storage
import Kingfisher


class PodcastCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var podcastImageView: UIImageView!
    @IBOutlet private weak var podcastTitleLabel: UILabel!
    @IBOutlet private weak var podcastDescriptionLabel: UILabel!
    @IBOutlet weak var explicitContentIndicatorView: UIImageView!
    
    static let reuseIdentifier = "PodcastCollectionViewCell"

    func updateContents(with podcast: PodcastViewModel) {
        podcastImageView.kf.setImage(with: podcast.image)
        podcastTitleLabel.text = podcast.title
        podcastDescriptionLabel.text = podcast.podcastDescription
        explicitContentIndicatorView.isHidden = !podcast.explicit
    }

}
