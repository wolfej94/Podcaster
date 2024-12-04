//
//  ContentViewModel.swift
//  
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

enum ContentViewAction {
    typealias Handler = (Self) -> Void
}

@Observable final class ContentViewModel: ViewModel {

    var actionHandler: ContentViewAction.Handler?

    init(actionHandler: @escaping ContentViewAction.Handler) {
        self.actionHandler = actionHandler
    }
}
