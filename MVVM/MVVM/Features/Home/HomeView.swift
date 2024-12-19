//
//  HomeView.swift
//  MVVM
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

struct HomeView: View {

    @State var viewModel: HomeViewModel

    var body: some View {
        VStack {
            if viewModel.state == .loading {
                ProgressView()
                    .foregroundStyle(Color.white)
            } else {
                contentView
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top)
        .background {
            Color.black
                .ignoresSafeArea()
        }
        .onAppear {
            viewModel.refreshPodcasts(ignoreCache: true)
        }
    }

    var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 20)
            VStack(alignment: .leading, spacing: 10) {
                Button(
                    action: {},
                    label: {
                        HStack(spacing: 5) {
                            Text("Popular Shows")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(Color.white)
                    }
                )
                .padding(.horizontal, 20)
                collectionView
            }

        }
    }

    var collectionView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(viewModel.podcasts) { podcast in
                    PodcastCell(podcast: podcast)
                        .frame(width: 200, height: 300)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 300)
    }

}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
