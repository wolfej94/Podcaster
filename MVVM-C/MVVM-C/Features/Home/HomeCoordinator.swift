//
//  HomeCoordinator.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

struct HomeCoordinator: View {

    var body: some View {
        let viewModel = HomeViewModel(actionHandler: handleHomeAction(_:))
        HomeView(viewModel: viewModel)
    }

    private func handleHomeAction(_ action: HomeViewAction) {

    }

}

