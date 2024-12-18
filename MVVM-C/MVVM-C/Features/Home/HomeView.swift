//
//  HomeView.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

struct HomeView: View {

    @State var viewModel: HomeViewModel

    var body: some View {
        Color.blue
            .edgesIgnoringSafeArea(.top)
            .tabItem { viewModel.tabItem }
    }
}

