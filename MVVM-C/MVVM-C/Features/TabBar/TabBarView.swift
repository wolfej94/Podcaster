//
//  TabBarView.swift
//
//
//  Created by James Wolfe on 04/12/2024.
//

import SwiftUI

struct TabBarView: View {

    var body: some View {
        TabView {
            HomeCoordinator()
            SearchCoordinator()
        }
    }
}
