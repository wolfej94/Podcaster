//
//  SearchView.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

struct SearchView: View {

    @State var viewModel: SearchViewModel

    var body: some View {
        Color.red
            .edgesIgnoringSafeArea(.top)
            .tabItem { viewModel.tabItem }
    }
}
