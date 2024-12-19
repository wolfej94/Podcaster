//
//  ViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import SwiftUI

/// A ViewModel class conforming to `ObservableObject` that manages the state of a view in a SwiftUI application.
@Observable open class ViewModel: NSObject {

    /// The current state of the user interface, published to update views when changed.
    private(set) var state: UIState

    /// Initializes the ViewModel with an optional initial state, defaulting to `.loading`.
    /// - Parameter state: The initial state of the ViewModel. Default is `.loading`.
    init(state: UIState = .loading) {
        self.state = state
    }

    /// Sets the state of the ViewModel with an optional animation.
    /// - Parameters:
    ///   - state: The new state to set.
    ///   - animation: The animation to use when setting the state. Default is `.default`.
    func setState(to state: UIState, animation: Animation = .default) {
        withAnimation(animation) {
            self.state = state
            if case .error = state {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(2)) { [weak self] in
                    self?.setState(to: .loaded)
                }
            }
        }
    }

    /// Asynchronously sets the state of the ViewModel with an optional animation.
    /// - Parameters:
    ///   - state: The new state to set.
    ///   - animation: The animation to use when setting the state. Default is `.default`.
    @MainActor
    func setState(to state: UIState, animation: Animation = .default) async {
        await MainActor.run {
            self.setState(to: state, animation: animation)
        }
    }
}

extension ViewModel {
    /// An enumeration representing the different states the user interface can be in.
    enum UIState: Equatable {
        /// Represents an error state with an associated error message.
        case error(message: String)

        /// Represents a loading state.
        case loading

        /// Represents a loaded state, indicating that data has been successfully loaded.
        case loaded
    }
}
