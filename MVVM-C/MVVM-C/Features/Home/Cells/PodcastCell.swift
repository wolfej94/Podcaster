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
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(
                    url: podcast.image,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.width)
                    },
                    placeholder: {
                        Color.gray
                            .frame(width: proxy.size.width, height: proxy.size.width)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                )
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
}
