//
//  SearchCoordinator.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

struct SearchCoordinator: View {

    var body: some View {
        let viewModel = SearchViewModel(actionHandler: handleSearchAction(_:))
        SearchView(viewModel: viewModel)
    }

    private func handleSearchAction(_ action: SearchViewAction) {

    }

}
