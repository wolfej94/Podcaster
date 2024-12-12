//
//  ContentView.swift
//  MVVM-C
//
//  Created by James Wolfe on 02/12/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State var viewModel: ContentViewModel

    var body: some View {
        Text("Hello World")
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(actionHandler: { _ in }))
}
