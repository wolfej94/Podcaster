//
//  ContentCoordinator.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

struct ContentCoordinator: View {

    var body: some View {
        let viewModel = ContentViewModel(actionHandler: handleViewAction(_:))
        NavigationStack {
            ContentView(viewModel: viewModel)
        }
    }

    func handleViewAction(_ action: ContentViewAction) {

    }
}
