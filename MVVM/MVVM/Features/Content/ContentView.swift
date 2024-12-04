//
//  ContentView.swift
//  MVVM
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

struct ContentView: View {

    @State var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
