//
//  MVVM_CApp.swift
//  MVVM-C
//
//  Created by James Wolfe on 02/12/2024.
//

import SwiftUI

@main
struct MVVM_CApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
