//
//  HomeViewModel.swift
//  MVVM-C
//
//  Created by James Wolfe on 18/12/2024.
//

import SwiftUI

enum HomeViewAction {
    typealias Handler = (Self) -> Void
}

@Observable final class HomeViewModel: ViewModel {

    let actionHandler: HomeViewAction.Handler
    let tabItem: Label = Label("home", systemImage: "house")

    init(actionHandler: @escaping HomeViewAction.Handler) {
        self.actionHandler = actionHandler
    }

}
