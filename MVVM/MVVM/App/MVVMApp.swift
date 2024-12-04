//
//  MVVMApp.swift
//  MVVM
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

@main
struct MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(viewModel: ContentViewModel())
            }
        }
    }
}
