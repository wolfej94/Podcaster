//
//  PodcastCell.swift
//  MVVM
//
//  Created by James Wolfe on 19/12/2024.
//

import SwiftUI
import Storage

struct PodcastCell: View {

    let podcast: PodcastViewModel

    var body: some View {
        VStack(spacing: 10) {
            AsyncImage(url: podcast.image)
                .aspectRatio(1, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack(alignment: .top, spacing: 5) {
                Text(podcast.title ?? "")
                    .lineLimit(2)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "e.square.fill")
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(Color.gray)
            }
            Text(podcast.podcastDescription ?? "")
                .lineLimit(2)
                .font(.caption)
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(alignment: .top)
    }
}
