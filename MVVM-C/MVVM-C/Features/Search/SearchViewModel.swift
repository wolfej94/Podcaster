//
//  SearchViewModel.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

enum SearchViewAction {
    typealias Handler = (Self) -> Void
}

@Observable final class SearchViewModel: ViewModel {

    let actionHandler: SearchViewAction.Handler
    let tabItem: Label = Label("Search", systemImage: "magnifyingglass")

    init(actionHandler: @escaping SearchViewAction.Handler) {
        self.actionHandler = actionHandler
    }
    
}
