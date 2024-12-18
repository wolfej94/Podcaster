//
//  TabBarView.swift
//  MVVM
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

struct TabBarView: View {

    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
            SearchView(viewModel: SearchViewModel())
        }
    }
}

#Preview {
    TabBarView()
}
